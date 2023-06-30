import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../links/links.dart';
import 'estonia_public_transport.dart';

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
        throw 'Failed to download the file. Status code: ${response.statusCode}';
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

  Future<bool> checkFileExistence() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePathTest = '${directory.path}/gtfs/stops.txt';
    if (File(filePathTest).existsSync()) {
      return true;
    } return false;
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
            longitude: double.parse(values[5]),);
      }
      return Stop(
          stopId: values[0],
          name: values[2],
          latitude: double.parse(values[3]),
          longitude: double.parse(values[4]),);
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
      List<StopTime> stopTimeListForOneStop, List<Trip> allTrips,) {
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
  Future<List<StopTime>> parseStopTimes(List<Trip> trips) async {
    final tripsMap = await _makeTripsMap(trips);
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final stopTimesFile = File('${documentsDirectory.path}/gtfs/stop_times.txt');
    final stopTimesData = await stopTimesFile.readAsString();

    final stopTimes = LineSplitter.split(stopTimesData)
        .skip(1)
        .map((line) {
          final values = line.split(',');
          final tripId = values[0];
          final trip = tripsMap[tripId];
          if (trip == null) {
            return null;
          }
          return StopTime(
            tripId: values[0],
            stopId: values[3],
            arrivalTime: values[1],
            departureTime: values[2],
            sequence: int.parse(values[4]),
          );
        })
        .where((trip) => trip != null)
        .cast<StopTime>()
        .toList();
    return stopTimes;
  }
  /// Parse trips from trips.txt. Here we also check is trip goes now, not
  /// in the future or not in the past.
  Future<List<Trip>> parseTrips(List<Calendar> calendar) async {
    final calendarMap = await _makeCalendarMap(calendar);
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final tripsFile = File('${documentsDirectory.path}/gtfs/trips.txt');
    final tripsData = await tripsFile.readAsString();

    final trips = LineSplitter.split(tripsData)
        .skip(1)
        .map((line) {
          final values = line.split(',');
          final serviceId = values[1];
          final calendar = calendarMap[serviceId];
          if (calendar == null) {
            return null;
          }
          // if shapeId is empty, do not include in list
          return Trip(
              tripId: values[2], routeId: values[0], serviceId: values[1], shapeId: values[6],);
        })
        .where((trip) => trip != null && trip.shapeId != '')
        .cast<Trip>()
        .toList();
    return trips;
  }
  /// Parse calendar from calendar.txt. Important note: here we get services
  /// which are available now, not in the future, not in the past.
  Future<List<Calendar>> parseCalendar() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final calendarFile = File('${documentsDirectory.path}/gtfs/calendar.txt');
    final calendarData = await calendarFile.readAsString();
    final currentDate = DateTime.now();

    final calendar = LineSplitter.split(calendarData)
        .skip(1)
        .map<Calendar?>((line) {
          final values = line.split(',');
          final startDate = DateTime.parse(
              '${values[8].substring(0, 4)}-${values[8].substring(4, 6)}-${values[8].substring(6, 8)}',);
          final endDate = DateTime.parse(
              '${values[9].substring(0, 4)}-${values[9].substring(4, 6)}-${values[9].substring(6, 8)}',);
          if (!(startDate.isAfter(currentDate) || endDate.isBefore(currentDate))) {
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
            .toList(),);

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
    final calendarMap = { for (var item in calendar) item.serviceId : item };
    return calendarMap;
  }

  /// Make Trip Map<dynamic, dynamic> out of List<Trip>.
  Future<Map<dynamic, dynamic>> _makeTripsMap(List<Trip> trips) async {
    final tripsMap = { for (var item in trips) item.tripId : item };
    return tripsMap;
  }
}
