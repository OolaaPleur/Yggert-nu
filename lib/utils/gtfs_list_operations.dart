import '../domain/estonia_public_transport/estonia_public_transport.dart';

/// Defines a list of operations with GTFS data.
class GtfsListOperations {
  /// Returns List of [Calendar] for particular serviceId. Function needed to
  /// get list of days, when trip is going.
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
}
