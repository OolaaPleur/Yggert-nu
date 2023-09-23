import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yggert_nu/constants/api_links.dart';
import 'package:yggert_nu/data/repositories/settings_repository.dart';
import 'package:yggert_nu/exceptions/exceptions.dart';
import 'package:yggert_nu/utils/io/io_operations.dart';

import '../../constants/constants.dart';
import '../../utils/database/database_operations.dart';
import '../models/estonia_public_transport.dart';

/// Class, which provides functions related to working with GTFS-data,
/// such as downloading gtfs.zip, unarchiving it, deleting gtfs.zip and
/// working with .txt files located in new gtfs folder.
class EstoniaPublicTransportApiProvider {
  final _log = Logger('EstoniaPublicTransportApiProvider');
  final _settingsRepository = GetIt.I<SettingsRepository>();

  Future<void> _fetchFirstTime() async {
    final path = await IOOperations.getAppDirForPlatform();
    final dbpath = await IOOperations.getDbDirForPlatform();
    final filePath = '$path/gtfs.zip';

    await IOOperations.deleteDatabaseIfExists('$dbpath/routes.db');
    await IOOperations.deleteDatabaseIfExists('$dbpath/stop_times.db');
    await IOOperations.deleteDatabaseIfExists('$dbpath/trips.db');
    if (Directory('$path/gtfs').existsSync()) {
      Directory('$path/gtfs').deleteSync(recursive: true);
    }
    final apiLinks = GetIt.instance<ApiLinks>();
    final url = Uri.parse(apiLinks.gtfsLink);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      IOOperations.unzipFile(filePath, '$path/gtfs');
      await IOOperations.deleteFile('gtfs/shapes.txt');
      await IOOperations.deleteFile('gtfs/fare_rules.txt');
      await _settingsRepository.setStringValue('gtfs_download_date', file.lastModifiedSync().toString());
      _log.finer('File downloaded and unzipped successfully.');
    } else {
      throw HttpException('Failed to download the file. Status code: ${response.statusCode}');
    }
  }

  /// Fetch first time data, download gtfs.zip, unarchive it, delete gtfs.zip.
  Future<InfoMessage> fetchData() async {
    final infoMessage = await _checkGtfsDownloadDate();
    if (infoMessage == InfoMessage.noNeedToDownload) {
      return InfoMessage.noNeedToDownload;
    }
    try {
      await _fetchFirstTime();
      final path = await IOOperations.getAppDirForPlatform();
      final filePath = '$path/gtfs.zip';
      if (File(filePath).existsSync()) {
        await IOOperations.deleteFile('gtfs.zip');
        return InfoMessage.fileDownloadedAndProcessed;
      }

      throw const GtfsZipIsNotPresent();
    } on SocketException {
      throw const NoInternetConnection();
    } catch (e) {
      rethrow;
    }
  }

  Future<InfoMessage> _checkGtfsDownloadDate() async {
    final downloadDate = await _settingsRepository.getStringValue('gtfs_download_date');
    final now = DateTime.now();

    //DateTime yesterday = DateTime.now().add(Duration(days: 1)); // yesterday, for testing purposes.
    try {
      final parsedDateTime = DateTime.parse(downloadDate);
      if (parsedDateTime.year == now.year &&
          parsedDateTime.month == now.month &&
          parsedDateTime.day == now.day) {
        return InfoMessage.noNeedToDownload;
      }
    } catch (e) {
      _log.fine('Need to download');
    }
    return InfoMessage.needToDownload;
  }

  /// Parse stopTimes from stop_times.txt.
  Future<void> parseStopTimes() async {
    final gtfsData = await IOOperations.openFile('stop_times.txt');
    if (gtfsData == '') {
      return;
    }
    final stopTimesDb = await DatabaseOperations.openAppDatabase('gtfs');
    await DatabaseOperations.createTable(stopTimesDb, 'stop_times', '''
    trip_id TEXT, arrival_time TEXT, departure_time TEXT, stop_id TEXT, sequence INTEGER''');

    final tripsDb = await DatabaseOperations.openAppDatabase('gtfs');

    final tripsMap = await _getTripsMap(tripsDb);
    final stopTimesDataList = _parseStopTimes(gtfsData, tripsMap);

    await DatabaseOperations.insertDataBatch(stopTimesDb, 'stop_times', stopTimesDataList);
    await IOOperations.deleteFile('gtfs/stop_times.txt');
    await DatabaseOperations.closeDatabase(stopTimesDb);
    await DatabaseOperations.closeDatabase(tripsDb);
  }
  /// Parse stopTimes from stops.txt.
  Future<List<Stop>> parseStops() async {
    final gtfsData = await IOOperations.openFile('stops.txt');
    if (gtfsData == '') {
      return [];
    }
    final stopsDb = await DatabaseOperations.openAppDatabase('gtfs');
    await DatabaseOperations.createTable(stopsDb, 'stops', '''
    stop_id TEXT, stop_name TEXT, stop_lat DOUBLE, stop_lon DOUBLE''');

    final stopTimesDataList = await _parseStops();

    await DatabaseOperations.insertDataBatch(stopsDb, 'stops', stopTimesDataList.$2);
    await DatabaseOperations.closeDatabase(stopsDb);
    return stopTimesDataList.$1;
  }

  /// Parse trips from trips.txt. Here we also check is trip goes now, not
  /// in the future or not in the past.
  Future<void> parseTrips(List<Calendar> calendar) async {
    final calendarMap = await _makeCalendarMap(calendar);

    final database = await DatabaseOperations.openAppDatabase('gtfs');

    await DatabaseOperations.createTable(
      database,
      'trips',
      '''trip_id TEXT, route_id TEXT, service_id TEXT, trip_headsign TEXT, direction_id TEXT, shape_id TEXT, wheelchair_accessible TEXT''',
    );
    final gtfsData = await IOOperations.openFile('trips.txt');
    if (gtfsData == '') {
      // Handle the error, e.g., by returning early
      return;
    }
    final tripDataList = _parseAndCheckTrips(gtfsData, calendarMap);
    await DatabaseOperations.insertDataBatch(database, 'trips', tripDataList);
    await IOOperations.deleteFile('gtfs/trips.txt');
    await DatabaseOperations.closeDatabase(database);
  }

  /// Parse routes from routes.txt to routes.db.
  Future<void> parseRoutes() async {
    _log.info('Starting to parse routes.');
    final database = await DatabaseOperations.openAppDatabase('gtfs');
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
      _log.warning('Routes file is empty.');
      return;
    }
    final lines = LineSplitter.split(gtfsData).skip(1).toList();
    final listForRoutes = <Map<String, dynamic>>[];

    for (var i = 0; i < lines.length; i++) {
      int routeType;
      final values = lines[i].split(',');
      if (values.length < 7) {
        _log.warning('Invalid data at line ${i + 2}.');
        continue;
      }
      try {
        routeType = int.parse(values[4]);
      } catch (e) {
        _log.warning('Error parsing route type on line ${i + 2}: $e');
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
    await IOOperations.deleteFile('gtfs/routes.txt');
    _log.info('Finished parsing routes.');
  }

  /// Make Calendar Map<dynamic, dynamic> out of List<Calendar>.
  Future<Map<dynamic, dynamic>> _makeCalendarMap(List<Calendar> calendar) async {
    final calendarMap = {for (final item in calendar) item.serviceId: item};
    return calendarMap;
  }

  List<Map<String, dynamic>> _parseAndCheckTrips(
    String gtfsData,
    Map<dynamic, dynamic> calendarMap,
  ) {
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
      for (final trip in tripsList) trip['trip_id']: Trip.fromMap(trip)
    ,}; // Ensure to implement fromMap function in Trip class
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
  /// Parse stops from stops.txt.
  Future<(List<Stop>, List<Map<String, dynamic>>)> _parseStops() async {
    final stopsDataList = <Map<String, dynamic>>[];
    final stopsData = await IOOperations.openFile('stops.txt');

    final stops = LineSplitter.split(stopsData).skip(1).map((line) {
      final values = line.split(',');
      if (values[2].startsWith('"') && values[3].endsWith('"')) {
        //print(line);
        final stop = Stop(
          stopId: values[0],
          name: values[2],
          latitude: double.parse(values[4]),
          longitude: double.parse(values[5]),
        );
        stopsDataList.add(stop.toMap());
        return stop;
      }
      final stop = Stop(
        stopId: values[0],
        name: values[2],
        latitude: double.parse(values[3]),
        longitude: double.parse(values[4]),
      );
      stopsDataList.add(stop.toMap());
      return stop;
    }).toList();
    return (stops, stopsDataList);
  }
}
