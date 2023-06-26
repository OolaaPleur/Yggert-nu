import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'estonia_public_transport.dart';

class EstoniaPublicTransportApiProvider {
  Future<void> fetchFirstTime() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final filePathTest = '${directory.path}/gtfs/stops.txt';
    final filePath = '${directory.path}/gtfs.zip';

    if (await File(filePathTest).exists()) {
      log("File exists");
      return;
    } else {
      log("File don't exists");
      final url = Uri.parse('http://www.peatus.ee/gtfs/gtfs.zip');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        unzipFile(filePath, '${directory.path}/gtfs');
        log('File downloaded and unzipped successfully.');
      } else {
        log(
            'Failed to download the file. Status code: ${response.statusCode}');
      }
    }
  }

  void unzipFile(String zipFilePath, String destinationDir) {
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

  Future<void> deleteFile(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/$fileName';

    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        log('File deleted: $filePath');
      } else {
        log('File not found: $filePath');
      }
    } catch (e) {
      log('Error deleting file: $e');
    }
  }

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
            longitude: double.parse(values[5]));
      }
      return Stop(
          stopId: values[0],
          name: values[2],
          latitude: double.parse(values[3]),
          longitude: double.parse(values[4]));
    }).toList();
    return stops;
  }

  Future<void> fetchData() async {
    await fetchFirstTime();
    await deleteFile('gtfs.zip');
  }

  Future<List<StopTime>> getStopTimesForOneStop(
      String stopId, List<StopTime> stopTimeList) async {
    return stopTimeList.where((stopTime) => stopTime.stopId == stopId).toList();
  }

  Future<List<Trip>> getTripsForOneStopForAllStopTimes(
      List<StopTime> stopTimeListForOneStop, List<Trip> allTrips) async {
    List<Trip> matchingTrips = [];
    for (Trip trip in allTrips) {
      for (StopTime stopTime in stopTimeListForOneStop) {
        if (trip.tripId == stopTime.tripId) {
          matchingTrips.add(trip);
        }
      }
    }
    return matchingTrips;
  }

  Future<List<StopTime>> parseStopTimes() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final stopTimesFile =
        File('${documentsDirectory.path}/gtfs/stop_times.txt');
    final stopTimesData = await stopTimesFile.readAsString();

    final stopTimes = LineSplitter.split(stopTimesData).skip(1).map((line) {
      final values = line.split(',');
      return StopTime(
        tripId: values[0],
        stopId: values[3],
        arrivalTime: values[1],
        departureTime: values[2],
        sequence: int.parse(values[4]),
      );
    }).toList();
    return stopTimes;
  }

  Future<List<Trip>> parseTrips() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final tripsFile = File('${documentsDirectory.path}/gtfs/trips.txt');
    final tripsData = await tripsFile.readAsString();

    final trips = LineSplitter.split(tripsData).skip(1).map((line) {
      final values = line.split(',');
      return Trip(tripId: values[2], routeId: values[0], serviceId: values[1]);
    }).toList();
    return trips;
  }

  Future<List<Calendar>> parseCalendar() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final calendarFile = File('${documentsDirectory.path}/gtfs/calendar.txt');
    final calendarData = await calendarFile.readAsString();

    final calendar = LineSplitter.split(calendarData).skip(1).map((line) {
      final values = line.split(',');
      return Calendar(
        serviceId: values[0],
        daysOfWeek: values.sublist(1, 8).map((day) => day == '1').toList(),
      );
    }).toList();
    return calendar;
  }

  List<Calendar> getCalendarForService(
      String serviceId, List<Calendar> allCalendars) {
    return allCalendars
        .where((calendar) => calendar.serviceId == serviceId)
        .toList();
  }
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
    var weekdaysShort = weekdaysFull.map((day) => day.substring(0, 3)).toList();
    final activeDays = tripCalendars
        .map((calendar) => calendar.daysOfWeek)
        .reduce((combinedDays, currentDays) => combinedDays
        .asMap()
        .entries
        .map((entry) => entry.value || currentDays[entry.key])
        .toList());

    final activeDayNames = activeDays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => weekdaysShort[entry.key])
        .toList();

    return activeDayNames.join(', ');
  }
}
