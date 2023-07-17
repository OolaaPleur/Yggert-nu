import 'dart:convert';


import '../../utils/io/io_operations.dart';
import '../models/estonia_public_transport.dart';

/// Class, which defines functions, which purpose to work with GTFS files.
class GTFSFileSource {
  /// Parse calendar from calendar.txt. Important note: here we get services
  /// which are available now, not in the future, not in the past.
  Future<List<Calendar>> parseCalendar() async {
    final calendarData = await IOOperations.openFile('calendar.txt');
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
}
