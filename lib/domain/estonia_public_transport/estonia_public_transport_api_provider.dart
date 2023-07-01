import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../links/links.dart';
import 'estonia_public_transport.dart';

class ParseStopTimesParams {
  final List<Trip> trips;
  final String stopTimesData;
  final String dbpath;

  ParseStopTimesParams({required this.trips, required this.stopTimesData, required this.dbpath});
}

/// Class, which provides functions related to working with GTFS-data,
/// such as downloading gtfs.zip, unarchiving it, deleting gtfs.zip and
/// working with .txt files located in new gtfs folder.
class EstoniaPublicTransportApiProvider {
  Future<void> _fetchFirstTime() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePathTest = '${directory.path}/gtfs/stops.txt';
    final filePath = '${directory.path}/gtfs.zip';

    if (File(filePathTest).existsSync()) {
      log('File exists');
      return;
    } else {
      log("File don't exists");
      final url = Uri.parse(Links.gtfsLink);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        _unzipFile(filePath, '${directory.path}/gtfs');
        log('File downloaded and unzipped successfully.');
      } else {
        throw HttpException('Failed to download the file. Status code: ${response.statusCode}');
      }
    }
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
  Future<void> fetchData() async {
    try {
      await _fetchFirstTime();
      await _deleteFile('gtfs.zip');
    } catch (e) {
      throw Exception('Check internet connection or give storage permissions');
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
            "CREATE TABLE IF NOT EXISTS stopTimes(tripId TEXT, arrivalTime TEXT, departureTime TEXT, stopId TEXT, sequence INTEGER)",
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
      int count = 0;
      final lines = LineSplitter.split(stopTimesData).skip(1).toList();
      for (var i = 0; i < lines.length; i++) {
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
          if (i % 100000 == 0) {
            print(i);
            await batch.commit(noResult: true);
            batch = stopTimesDb.batch();
          }
          count++;
        }
      }
      print('number of entries = ${count}');
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
    String path = join(dbpath, 'trips.db');

    if (!File(path).existsSync()) {
      final db = await openDatabase(
        join(dbpath, 'trips.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE IF NOT EXISTS trips(tripId TEXT, routeId TEXT, serviceId TEXT, tripHeadsign TEXT, directionId TEXT, wheelchairAccessible TEXT, shapeId TEXT)",
          );
        },
        version: 1,
      );

      var batch = db.batch();
      final lines = LineSplitter.split(tripsData).skip(1).toList();
      for (int i = 0; i < lines.length; i++) {
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

  Future<void> parseRoutes() async {
    // Get the path to the database.
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'routes.db');

    if (!File(path).existsSync()) {
      // Open the database.
      final database = await openDatabase(path, version: 1,
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
            competent_authority TEXT, 
            route_desc TEXT
          )
        ''');

          });

      // Read the file.
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final routesFile = File('${documentsDirectory.path}/gtfs/routes.txt');
      final routesData = await routesFile.readAsString();
      var batch = database.batch();
      final lines = LineSplitter.split(routesData).skip(1).toList();

      int count = 0;
      for (var i = 1; i < lines.length; i++) {
        var values = lines[i].split(',');

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
            routeDesc: values[7],
          );

          batch.insert('Routes', route.toMap());
        });
        count++;
      }
      await batch.commit(noResult: true);
      await database.close();
      print(count);
    }

  }

  /// Returns List of [Calendar] object for corresponding serviceId
  List<Calendar> getCalendarForService(String serviceId, List<Calendar> allCalendars) {
    return allCalendars.where((calendar) => calendar.serviceId == serviceId).toList();
  }

  /// Transforms List of daysOfWeek true/false into string with
  /// corresponding days of the week.
  String getDaysOfWeekString(List<Calendar> tripCalendars) {
    final weekdaysFull = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final weekdaysShort = weekdaysFull.map((day) => day.substring(0, 3)).toList();
    final activeDays = tripCalendars.map((calendar) => calendar.daysOfWeek).reduce(
          (combinedDays, currentDays) => combinedDays
              .asMap()
              .entries
              .map((entry) => entry.value || currentDays[entry.key])
              .toList(),
        );

    final activeDayNames = activeDays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => weekdaysShort[entry.key])
        .toList();

    return activeDayNames.join(', ');
  }

  /// Make Calendar Map<dynamic, dynamic> out of List<Calendar>.
  Future<Map<dynamic, dynamic>> _makeCalendarMap(List<Calendar> calendar) async {
    final calendarMap = {for (var item in calendar) item.serviceId: item};
    return calendarMap;
  }
}
