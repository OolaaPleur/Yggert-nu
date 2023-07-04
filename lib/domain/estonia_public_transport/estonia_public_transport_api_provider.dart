import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:mobility_app/domain/device_settings/device_settings.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../links/links.dart';
import 'estonia_public_transport.dart';

/// Class, which provides functions related to working with GTFS-data,
/// such as downloading gtfs.zip, unarchiving it, deleting gtfs.zip and
/// working with .txt files located in new gtfs folder.
class EstoniaPublicTransportApiProvider {
  /// Progress controller for parse stop_times.db
  BehaviorSubject<int> progressController = BehaviorSubject<int>();
  int _previousProgress = 0;

  Future<String> _fetchFirstTime() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbpath = await getDatabasesPath();
    final filePath = '${directory.path}/gtfs.zip';

    final deviceSettings = DeviceSettings();
    final downloadDate = await deviceSettings.getValue('gtfs_download_date');
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
    if (File('$dbpath/routes.db').existsSync()) {
      await deleteDatabase('$dbpath/routes.db');
    }
    if (File('$dbpath/stop_times.db').existsSync()) {
      await deleteDatabase('$dbpath/stop_times.db');
    }
    if (File('$dbpath/trips.db').existsSync()) {
      await deleteDatabase('$dbpath/trips.db');
    }
    if (Directory('${directory.path}/gtfs').existsSync()) {
      Directory('${directory.path}/gtfs').deleteSync(recursive: true);
    }

    final url = Uri.parse(Links.gtfsLink);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      _unzipFile(filePath, '${directory.path}/gtfs');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gtfs_download_date', file.lastModifiedSync().toString());
      log('File downloaded and unzipped successfully.');
    } else {
      throw HttpException('Failed to download the file. Status code: ${response.statusCode}');
    }
    return '';
  }

  void _unzipFile(String zipFilePath, String destinationDir) {
    final bytes = File(zipFilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final fileName = file.name;

      if (file.isFile) {
        final data = file.content as List<int>;
        File('$destinationDir/$fileName')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$destinationDir/$fileName').create(recursive: true);
      }
    }
  }

  Future<void> _deleteFile(String fileName) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDocumentsDirectory.path}/$fileName';

    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
        log('File deleted: $filePath');
      } else {
        log('File not found: $filePath');
      }
    } catch (e) {
      log('Error deleting file: $e');
    }
  }

  /// Checks GTFS file existence.
  Future<bool> checkFileExistence() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePathTest = '${directory.path}/gtfs/stops.txt';
    if (File(filePathTest).existsSync()) {
      return true;
    }
    return false;
  }

  /// Parse stops from stops.txt.
  Future<List<Stop>> parseStops() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final stopsFile = File('${documentsDirectory.path}/gtfs/stops.txt');
    final stopsData = await stopsFile.readAsString();

    final stops = LineSplitter.split(stopsData).skip(1).map((line) {
      final values = line.split(',');
      if (values[2].startsWith('"') && values[3].endsWith('"')) {
        //print(line);
        return Stop(
          stopId: values[0],
          name: values[2],
          latitude: double.parse(values[4]),
          longitude: double.parse(values[5]),
        );
      }
      return Stop(
        stopId: values[0],
        name: values[2],
        latitude: double.parse(values[3]),
        longitude: double.parse(values[4]),
      );
    }).toList();
    return stops;
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
        await _deleteFile('gtfs.zip');
        return 'File downloaded and processed successfully.';
      }
      return 'Unknown Error';
    } on SocketException {
      throw Exception('No Internet connection. Please check your connection and try again.');
    } catch (e) {
      rethrow;
    }
  }

  /// Return List of [StopTime] objects related to one [Stop].
  List<StopTime> getStopTimesForOneStop(String stopId, List<StopTime> stopTimeList) {
    return stopTimeList.where((stopTime) => stopTime.stopId == stopId).toList();
  }

  /// Return trips based on stopTimes list for picked stop.
  List<Trip> getTripsForOneStopForAllStopTimes(
    List<StopTime> stopTimeListForOneStop,
    List<Trip> allTrips,
  ) {
    final matchingTrips = <Trip>[];
    for (final trip in allTrips) {
      for (final stopTime in stopTimeListForOneStop) {
        if (trip.tripId == stopTime.tripId) {
          matchingTrips.add(trip);
        }
      }
    }
    return matchingTrips;
  }

  /// Parse stopTimes from stop_times.txt.
  Future<void> parseStopTimes() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final stopTimesFile = File('${documentsDirectory.path}/gtfs/stop_times.txt');
    final stopTimesData = await stopTimesFile.readAsString();
    final dbpath = await getDatabasesPath();

    // Initialize the database
    final tripsPath = join(dbpath, 'trips.db');

    // Initialize the database
    final path = join(dbpath, 'stop_times.db');
    if (!File(path).existsSync()) {
      final stopTimesDb = await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS stopTimes(tripId TEXT, arrivalTime TEXT, departureTime TEXT, stopId TEXT, sequence INTEGER)',
          );
        },
        version: 1,
      );

      final tripsDb = await openDatabase(
        tripsPath,
        version: 1,
      );
      final tripsList = await tripsDb.query('trips');
      final tripsMap = {
        for (var trip in tripsList) trip['tripId']: Trip.fromMap(trip)
      }; // Ensure to implement fromMap function in Trip class

      var batch = stopTimesDb.batch(); // create batch for multiple insertions
      var count = 0;
      final lines = LineSplitter.split(stopTimesData).skip(1).toList();
      final total = lines.length;

      for (var i = 0; i < lines.length; i++) {
        final progressPercent = (i + 1) / total * 100;
        final roundedProgress = progressPercent.round();
        if (roundedProgress != _previousProgress) {
          progressController.sink.add(roundedProgress);
          _previousProgress = roundedProgress;
        }

        final values = lines[i].split(',');
        final tripId = values[0];
        final trip = tripsMap[tripId];

        if (trip != null) {
          final stopTime = StopTime(
            tripId: values[0],
            arrivalTime: values[1],
            departureTime: values[2],
            stopId: values[3],
            sequence: int.parse(values[4]),
          );

          batch.insert('stopTimes', stopTime.toMap());
          if (i % 25000 == 0) {
            log(i.toString());
            await batch.commit(noResult: true);
            batch = stopTimesDb.batch();
          }
          count++;
        }
      }
     // await progressController.close();
      log('number of entries = $count');
      await batch.commit(noResult: true);
      await stopTimesDb.close();
      await tripsDb.close();
    }
  }

  /// Parse trips from trips.txt. Here we also check is trip goes now, not
  /// in the future or not in the past.
  Future<void> parseTrips(List<Calendar> calendar) async {
    final calendarMap = await _makeCalendarMap(calendar);
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final tripsFile = File('${documentsDirectory.path}/gtfs/trips.txt');
    final tripsData = await tripsFile.readAsString();
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'trips.db');

    if (!File(path).existsSync()) {
      final db = await openDatabase(
        join(dbpath, 'trips.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS trips(tripId TEXT, routeId TEXT, serviceId TEXT, tripHeadsign TEXT, directionId TEXT, wheelchairAccessible TEXT, shapeId TEXT)',
          );
        },
        version: 1,
      );

      var batch = db.batch();
      final lines = LineSplitter.split(tripsData).skip(1).toList();
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

          batch.insert('trips', trip.toMap());
        }

        if (i % 10000 == 0) {
          await batch.commit(noResult: true);
          batch = db.batch();
        }
      }
      await batch.commit(noResult: true);
      await db.close();
    }
  }

  /// Parse calendar from calendar.txt. Important note: here we get services
  /// which are available now, not in the future, not in the past.
  Future<List<Calendar>> parseCalendar() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final calendarFile = File('${documentsDirectory.path}/gtfs/calendar.txt');
    final calendarData = await calendarFile.readAsString();
    var currentDate = DateTime.now();

    final calendar = LineSplitter.split(calendarData)
        .skip(1)
        .map<Calendar?>((line) {
          final values = line.split(',');
          var startDate = DateTime.parse(
            '${values[8].substring(0, 4)}-${values[8].substring(4, 6)}-${values[8].substring(6, 8)}',
          );
          var endDate = DateTime.parse(
            '${values[9].substring(0, 4)}-${values[9].substring(4, 6)}-${values[9].substring(6, 8)}',
          );
          startDate = DateTime(startDate.year, startDate.month, startDate.day);
          endDate = DateTime(endDate.year, endDate.month, endDate.day);
          currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
          if (!(startDate.isAfter(currentDate) || endDate.isBefore(currentDate))) {
            return Calendar(
              serviceId: values[0],
              daysOfWeek: values.sublist(1, 8).map((day) => day == '1').toList(),
              startDate: startDate,
              endDate: endDate,
            );
          } else if (currentDate.isAtSameMomentAs(endDate) ||
              currentDate.isAtSameMomentAs(startDate)) {
            return Calendar(
              serviceId: values[0],
              daysOfWeek: values.sublist(1, 8).map((day) => day == '1').toList(),
              startDate: startDate,
              endDate: endDate,
            );
          }
          return null;
        })
        .where((element) => element != null)
        .cast<Calendar>()
        .toList();
    return calendar;
  }

  /// Parse routes from routes.txt to routes.db.
  Future<void> parseRoutes() async {
    // Get the path to the database.
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'routes.db');

    if (!File(path).existsSync()) {
      // Open the database.
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Create the table.
          await db.execute('''
          CREATE TABLE IF NOT EXISTS Routes(
            route_id TEXT PRIMARY KEY, 
            agency_id TEXT, 
            route_short_name TEXT, 
            route_long_name TEXT, 
            route_type INT, 
            route_color TEXT, 
            competent_authority TEXT
          )
        ''');
        },
      );

      // Read the file.
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final routesFile = File('${documentsDirectory.path}/gtfs/routes.txt');
      final routesData = await routesFile.readAsString();
      final batch = database.batch();
      final lines = LineSplitter.split(routesData).skip(1).toList();

      for (var i = 1; i < lines.length; i++) {
        final values = lines[i].split(',');

        // Insert data into the database.
        await database.transaction((txn) async {
          final route = Route(
            agencyId: values[1],
            routeId: values[0],
            routeShortName: values[2],
            routeLongName: values[3],
            routeType: int.parse(values[4]),
            routeColor: values[5],
            competentAuthority: values[6],
          );

          batch.insert('Routes', route.toMap());
        });
      }
      await batch.commit(noResult: true);
      await database.close();
    }
  }

  /// Make Calendar Map<dynamic, dynamic> out of List<Calendar>.
  Future<Map<dynamic, dynamic>> _makeCalendarMap(List<Calendar> calendar) async {
    final calendarMap = {for (var item in calendar) item.serviceId: item};
    return calendarMap;
  }
}
