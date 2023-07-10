import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:mobility_app/domain/device_settings.dart';
import 'package:mobility_app/utils/io/io_operations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../constants/api_links/api_links.dart';
import '../../domain/estonia_public_transport.dart';
import '../../utils/database/database_operations.dart';

/// Class, which provides functions related to working with GTFS-data,
/// such as downloading gtfs.zip, unarchiving it, deleting gtfs.zip and
/// working with .txt files located in new gtfs folder.
class EstoniaPublicTransportApiProvider {

  Future<String> _fetchFirstTime() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbpath = await getDatabasesPath();
    final filePath = '${directory.path}/gtfs.zip';

    final deviceSettings = DeviceSettings();
    final downloadDate = await deviceSettings.getStringValue('gtfs_download_date');
    final now = DateTime.now();

    //DateTime yesterday = DateTime.now().add(Duration(days: 1));
    try {
      final parsedDateTime = DateTime.parse(downloadDate);
      if (parsedDateTime.year == now.year &&
          parsedDateTime.month == now.month &&
          parsedDateTime.day == now.day) {
        return 'No need to download';
      }
    } catch (e) {
      //
    }
    await deleteDatabaseIfExists('$dbpath/routes.db');
    await deleteDatabaseIfExists('$dbpath/stop_times.db');
    await deleteDatabaseIfExists('$dbpath/trips.db');
    if (Directory('${directory.path}/gtfs').existsSync()) {
      Directory('${directory.path}/gtfs').deleteSync(recursive: true);
    }
    final apiLinks = GetIt.instance<ApiLinks>();
    final url = Uri.parse(apiLinks.gtfsLink);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      IOOperations.unzipFile(filePath, '${directory.path}/gtfs');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gtfs_download_date', file.lastModifiedSync().toString());
      log('File downloaded and unzipped successfully.');
    } else {
      throw HttpException('Failed to download the file. Status code: ${response.statusCode}');
    }
    return '';
  }

  /// Fetch first time data, download gtfs.zip, unarchive it, delete gtfs.zip.
  Future<String> fetchData() async {
    try {
      final message = await _fetchFirstTime();
      if (message == 'No need to download') {
        return 'No need to download';
      }
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/gtfs.zip';
      if (File(filePath).existsSync()) {
        await IOOperations.deleteFile('gtfs.zip');
        return 'File downloaded and processed successfully.';
      }
      return 'Unknown Error';
    } on SocketException {
      throw Exception('No Internet connection. Please check your connection and try again.');
    } catch (e) {
      rethrow;
    }
  }

  /// Parse stopTimes from stop_times.txt.
  Future<void> parseStopTimes() async {
    final gtfsData = await IOOperations.openFile('stop_times.txt');
    if (gtfsData == '') {
      return;
    }
    final databaseExists = await IOOperations.databaseExists('stop_times');
    if (databaseExists) {
      return;
    }

    final stopTimesDb = await DatabaseOperations.openAppDatabase('stop_times');
    await DatabaseOperations.createTable(stopTimesDb, 'stop_times', '''
    trip_id TEXT, arrival_time TEXT, departure_time TEXT, stop_id TEXT, sequence INTEGER''');

    final tripsDb = await DatabaseOperations.openAppDatabase('trips');

    final tripsMap = await _getTripsMap(tripsDb);
    final stopTimesDataList = _parseStopTimes(gtfsData, tripsMap);

    await DatabaseOperations.insertDataBatch(stopTimesDb, 'stop_times', stopTimesDataList);
    await DatabaseOperations.closeDatabase(stopTimesDb);
    await DatabaseOperations.closeDatabase(tripsDb);
  }

  /// Parse trips from trips.txt. Here we also check is trip goes now, not
  /// in the future or not in the past.
  Future<void> parseTrips(List<Calendar> calendar) async {
    final calendarMap = await _makeCalendarMap(calendar);

    final databaseExists = await IOOperations.databaseExists('trips');
    if (databaseExists) {
      return;
    }

    final database = await DatabaseOperations.openAppDatabase('trips');

    await DatabaseOperations.createTable(database, 'trips',
        '''trip_id TEXT, route_id TEXT, service_id TEXT, trip_headsign TEXT, direction_id TEXT, shape_id TEXT, wheelchair_accessible TEXT''',);
    final gtfsData = await IOOperations.openFile('trips.txt');
    if (gtfsData == '') {
      // Handle the error, e.g., by returning early
      return;
    }
    final tripDataList = _parseAndCheckTrips(gtfsData, calendarMap);
    await DatabaseOperations.insertDataBatch(database, 'trips', tripDataList);
    await DatabaseOperations.closeDatabase(database);
  }

  /// Parse routes from routes.txt to routes.db.
  Future<void> parseRoutes() async {
    final logger = Logger('parseRoutes');
    final databaseExists = await IOOperations.databaseExists('routes');
    if (databaseExists) {
      return;
    }
    logger.info('Starting to parse routes.');
    final database = await DatabaseOperations.openAppDatabase('routes');
    await DatabaseOperations.createTable(database, 'routes', '''
    route_id TEXT PRIMARY KEY,
        agency_id TEXT,
        route_short_name TEXT,
        route_long_name TEXT,
        route_type INT,
        route_color TEXT,
        competent_authority TEXT''');

    // Read the file.
    final gtfsData = await IOOperations.openFile('routes.txt');
    if (gtfsData == '') {
      logger.warning('Routes file is empty.');
      return;
    }
    final lines = LineSplitter.split(gtfsData).skip(1).toList();
    final listForRoutes = <Map<String, dynamic>>[];

    for (var i = 0; i < lines.length; i++) {
      int routeType;
      final values = lines[i].split(',');
      if (values.length < 7) {
        logger.warning('Invalid data at line ${i + 2}.');
        continue;
      }
      try {
        routeType = int.parse(values[4]);
      } catch (e) {
        logger.warning('Error parsing route type on line ${i + 2}: $e');
        continue;
      }
      final route = Route(
        agencyId: values[1],
        routeId: values[0],
        routeShortName: values[2],
        routeLongName: values[3],
        routeType: routeType,
        routeColor: values[5],
        competentAuthority: values[6],
      );
      listForRoutes.add(route.toMap());
    }
    // Commit the batch.
    await DatabaseOperations.insertDataBatch(database, 'routes', listForRoutes);
    // Close the database.
    await DatabaseOperations.closeDatabase(database);
    logger.info('Finished parsing routes.');
  }

  /// Make Calendar Map<dynamic, dynamic> out of List<Calendar>.
  Future<Map<dynamic, dynamic>> _makeCalendarMap(List<Calendar> calendar) async {
    final calendarMap = {for (var item in calendar) item.serviceId: item};
    return calendarMap;
  }

  List<Map<String, dynamic>> _parseAndCheckTrips(
      String gtfsData, Map<dynamic, dynamic> calendarMap,) {
    final tripDataList = <Map<String, dynamic>>[];
    final lines = LineSplitter.split(gtfsData).skip(1).toList();
    for (var i = 0; i < lines.length; i++) {
      final values = lines[i].split(',');
      final serviceId = values[1];
      final calendar = calendarMap[serviceId];
      if (calendar != null && values[6] != '') {
        // if shapeId is not empty, include in the database
        final trip = Trip(
          tripId: values[2],
          routeId: values[0],
          serviceId: values[1],
          tripHeadsign: values[3],
          directionId: values[5],
          wheelchairAccessible: values[7],
          shapeId: values[6],
        );

        tripDataList.add(trip.toMap());
      }
    }
    return tripDataList;
  }

  Future<Map<Object?, Trip>> _getTripsMap(Database db) async {
    final tripsList = await db.query('trips');
    final tripsMap = {
      for (var trip in tripsList) trip['trip_id']: Trip.fromMap(trip)
    }; // Ensure to implement fromMap function in Trip class
    return tripsMap;
  }

  List<Map<String, dynamic>> _parseStopTimes(String gtfsData, Map<Object?, Trip> tripsMap) {
    final stopTimesDataList = <Map<String, dynamic>>[];
    final lines = LineSplitter.split(gtfsData).skip(1).toList();
    for (var i = 0; i < lines.length; i++) {
      final values = lines[i].split(',');
      final tripId = values[0];
      final trip = tripsMap[tripId];

      if (trip != null) {
        final stopTime = StopTime(
          tripId: values[0],
          arrivalTime: values[1].substring(0, values[1].length - 3),
          departureTime: values[2].substring(0, values[2].length - 3),
          stopId: values[3],
          sequence: int.parse(values[4]),
        );
        stopTimesDataList.add(stopTime.toMap());
      }
    }
    return stopTimesDataList;
  }

  /// Delete a database if it exists
  Future<void> deleteDatabaseIfExists(String dbPath) async {
    if (File(dbPath).existsSync()) {
      await deleteDatabase(dbPath);
    }
  }
}
