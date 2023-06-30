import 'package:intl/intl.dart';

import '../domain/estonia_public_transport/estonia_public_transport.dart';
import '../domain/vehicle_repository.dart';

/// Class [FilterTripsForToday] created to make model for compute() function.
class FilterTripsForToday {
  /// Constructor of [FilterTripsForToday].
  FilterTripsForToday({
    required this.filteredByUserTrips,
    required this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    required this.pickedStop,
    required this.calendars,
    required this.vehicleRepository,
  });

  /// Filtered trips.
  final List<Trip> filteredByUserTrips;

  /// All Stop times for all trips which goes through current stop.
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;

  /// Currently picked stop.
  final Stop pickedStop;

  /// All calendar records.
  final List<Calendar> calendars;

  /// Vehicle repository, to access required functions.
  final VehicleRepository vehicleRepository;
}

/// Filter trips, so only today trips will be left.
List<Trip> filterTripsForToday(FilterTripsForToday data) {
  final todayWeekday = DateFormat.E().format(DateTime.now());
  final timeFormat = DateFormat('HH:mm:ss');
  final currentTimeString = timeFormat.format(DateTime.now());
  final currentTime = timeFormat.parse(currentTimeString);
  final filteredByUserTripsAfterApplyingToday = <Trip>[];
  var tripWillBeToday = false;

  for (final trip in data.filteredByUserTrips) {
    final tripStopTimes = data.allStopTimesForAllTripsWhichGoesThroughCurrentStop
        .where((stopTime) => stopTime.tripId == trip.tripId)
        .toList();

    for (final stopTime in tripStopTimes) {
      if ((timeFormat.parse(stopTime.departureTime).isAfter(currentTime)) &&
          stopTime.stopId == data.pickedStop.stopId) {
        tripWillBeToday = true;
        break;
      }
    }

    final tripCalendars =
        data.vehicleRepository.getCalendarForService(trip.serviceId, data.calendars);
    final stringOfWeekdays = data.vehicleRepository.getDaysOfWeekString(tripCalendars);

    if (stringOfWeekdays.contains(todayWeekday) && tripWillBeToday) {
      filteredByUserTripsAfterApplyingToday.add(trip);
      tripWillBeToday = false;
    }
  }
  return filteredByUserTripsAfterApplyingToday;
}

/// Class [RepaintTimeTable] was created to make model for compute() function.
class RepaintTimeTable {
  /// Constructor of [RepaintTimeTable].
  RepaintTimeTable({
    required this.filteredByUserTrips,
    required this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    required this.calendars,
    required this.currentStops,
    required this.pickedStop,
    required this.vehicleRepository,
  });

  /// Filtered trips.
  final List<Trip> filteredByUserTrips;

  /// All Stop times for all trips which goes through current stop.
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;

  /// Currently picked stop.
  final Stop pickedStop;

  /// All calendar records.
  final List<Calendar> calendars;

  /// Vehicle repository, to access required functions.
  final VehicleRepository vehicleRepository;

  /// Stops for currently picked stop.
  final List<Stop> currentStops;
}

/// Save values to maps, so they will be painted on modal bottom sheet.
Map<String, dynamic> repaintTimeTable(RepaintTimeTable data) {
  final presentStopStopTimeList = <int, StopTime>{};

  final presentTripStartStopTimes = <int, StopTime>{};
  final presentTripEndStopTimes = <int, StopTime>{};
  final presentTripStartStop = <int, Stop>{};
  final presentTripEndStop = <int, Stop>{};
  final presentTripCalendar = <int, String>{};

  var indexForAll = 0;
  for (final trip in data.filteredByUserTrips) {
    final tripStopTimes = data.allStopTimesForAllTripsWhichGoesThroughCurrentStop
        .where((stopTime) => stopTime.tripId == trip.tripId)
        .toList();
    final tripCalendars =
        data.vehicleRepository.getCalendarForService(trip.serviceId, data.calendars);
    presentTripCalendar[indexForAll] = data.vehicleRepository.getDaysOfWeekString(tripCalendars);

    presentTripStartStopTimes[indexForAll] =
        tripStopTimes.firstWhere((stopTime) => stopTime.sequence == 1);
    presentTripEndStopTimes[indexForAll] =
        tripStopTimes.lastWhere((stopTime) => stopTime.sequence == tripStopTimes.length);
    presentTripStartStop[indexForAll] = data.currentStops
        .firstWhere((stop) => stop.stopId == presentTripStartStopTimes[indexForAll]!.stopId);
    presentTripEndStop[indexForAll] = data.currentStops
        .firstWhere((stop) => stop.stopId == presentTripEndStopTimes[indexForAll]!.stopId);

    presentStopStopTimeList[indexForAll] = tripStopTimes.firstWhere(
      (stopTime) => stopTime.stopId == data.pickedStop.stopId,
      orElse: () =>
          StopTime(tripId: '', stopId: '', arrivalTime: '', departureTime: '', sequence: 0),
    );

    indexForAll += 1;
  }

  return {
    'presentStopStopTimeList': presentStopStopTimeList,
    'presentTripStartStopTimes': presentTripStartStopTimes,
    'presentTripEndStopTimes': presentTripEndStopTimes,
    'presentTripStartStop': presentTripStartStop,
    'presentTripEndStop': presentTripEndStop,
    'presentTripCalendar': presentTripCalendar,
  };
}

class CalculateCurrentListsForOneStop {
  CalculateCurrentListsForOneStop({
    required this.stopTimes,
    required this.busStops,
    required this.vehicleRepository,
    required this.trips,
    required this.stop,
  });

  final List<StopTime> stopTimes;
  final List<Stop> busStops;
  final VehicleRepository vehicleRepository;
  final List<Trip> trips;
  final Stop stop;
}

Map<String, dynamic> calculateCurrentListsForOneStop(CalculateCurrentListsForOneStop data) {
  final currentStopTimes =
      data.vehicleRepository.getStopTimesForOneStop(data.stop.stopId, data.stopTimes);
  final currentTrips =
      data.vehicleRepository.getTripsForOneStopForAllStopTimes(currentStopTimes, data.trips);

  currentStopTimes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

  currentTrips.sort((a, b) {
    final indexA = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == a.tripId);
    final indexB = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == b.tripId);
    return indexA.compareTo(indexB);
  });

  final currentTripIds = currentTrips.map((trip) => trip.tripId).toList();

  final allStopTimesForAllTripsWhichGoesThroughCurrentStop =
      data.stopTimes.where((stopTime) => currentTripIds.contains(stopTime.tripId)).toList();

  // getting list of unique stopIds from StopTimes
  final stopIds =
      allStopTimesForAllTripsWhichGoesThroughCurrentStop.map((stopTime) => stopTime.stopId).toSet();

  // filtering Stops based on the stopIds
  final currentStops = data.busStops.where((stop) => stopIds.contains(stop.stopId)).toList();

  return {
    'currentStopTimes': currentStopTimes,
    'currentTrips': currentTrips,
    'allStopTimesForAllTripsWhichGoesThroughCurrentStop':
        allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    'currentStops': currentStops,
    'currentTripIds': currentTripIds,
  };
}
