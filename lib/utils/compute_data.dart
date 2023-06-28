import 'package:intl/intl.dart';

import '../domain/estonia_public_transport/estonia_public_transport.dart';
import '../domain/vehicle_repository.dart';

class FilterTripsForToday {

  FilterTripsForToday({
    required this.filteredByUserTrips,
    required this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    required this.pickedStop,
    required this.calendars,
    required this.vehicleRepository,
    required this.todayWeekday,
    required this.currentTime,
  });
  final List<Trip> filteredByUserTrips;
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;
  final Stop pickedStop;
  final List<Calendar> calendars;
  final VehicleRepository vehicleRepository;
  final String todayWeekday;
  final DateTime currentTime;
}

List<Trip> filterTripsForToday(FilterTripsForToday data) {
  final filteredByUserTripsAfterApplyingToday = <Trip>[];
  var tripWillBeToday = false;
  final timeFormat = DateFormat('HH:mm:ss');

  for (final trip in data.filteredByUserTrips) {
    final tripStopTimes = data.allStopTimesForAllTripsWhichGoesThroughCurrentStop
        .where((stopTime) => stopTime.tripId == trip.tripId)
        .toList();

    for (final stopTime in tripStopTimes) {
      if ((timeFormat.parse(stopTime.departureTime).isAfter(data.currentTime)) &&
          stopTime.stopId == data.pickedStop.stopId) {
        tripWillBeToday = true;
        break;
      }
    }

    final tripCalendars = data.vehicleRepository.getCalendarForService(trip.serviceId, data.calendars);
    final stringOfWeekdays = data.vehicleRepository.getDaysOfWeekString(tripCalendars);

    if (stringOfWeekdays.contains(data.todayWeekday) && tripWillBeToday) {
      filteredByUserTripsAfterApplyingToday.add(trip);
      tripWillBeToday = false;
    }
  }
  return filteredByUserTripsAfterApplyingToday;
}

class RepaintTimeTable {

  RepaintTimeTable({
    required this.filteredByUserTrips,
    required this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    required this.calendars,
    required this.currentStops,
    required this.pickedStop,
    required this.vehicleRepository,
  });
  final List<Trip> filteredByUserTrips;
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;
  final List<Calendar> calendars;
  final List<Stop> currentStops;
  final Stop pickedStop;
  final VehicleRepository vehicleRepository;
}

Map<String, dynamic> processTrips(RepaintTimeTable data) {
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
    final tripCalendars = data.vehicleRepository.getCalendarForService(trip.serviceId, data.calendars);
    presentTripCalendar[indexForAll] = data.vehicleRepository.getDaysOfWeekString(tripCalendars);

    presentTripStartStopTimes[indexForAll] = tripStopTimes.firstWhere((stopTime) => stopTime.sequence == 1);
    presentTripEndStopTimes[indexForAll] =
        tripStopTimes.lastWhere((stopTime) => stopTime.sequence == tripStopTimes.length);
    presentTripStartStop[indexForAll] =
        data.currentStops.firstWhere((stop) => stop.stopId == presentTripStartStopTimes[indexForAll]!.stopId);
    presentTripEndStop[indexForAll] =
        data.currentStops.firstWhere((stop) => stop.stopId == presentTripEndStopTimes[indexForAll]!.stopId);

    presentStopStopTimeList[indexForAll] = tripStopTimes.firstWhere(
            (stopTime) => stopTime.stopId == data.pickedStop.stopId,
        orElse: () => StopTime(tripId: '', stopId: '', arrivalTime: '', departureTime: '', sequence: 0),);

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

class ComputeData {

  ComputeData({
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

Map<String, dynamic> processData(ComputeData data) {
  final currentStopTimes = data.vehicleRepository.getStopTimesForOneStop(data.stop.stopId, data.stopTimes);
  final currentTrips = data.vehicleRepository.getTripsForOneStopForAllStopTimes(currentStopTimes, data.trips);

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
  final stopIds = allStopTimesForAllTripsWhichGoesThroughCurrentStop.map((stopTime) => stopTime.stopId).toSet();

  // filtering Stops based on the stopIds
  final currentStops = data.busStops.where((stop) => stopIds.contains(stop.stopId)).toList();

  return {
    'currentStopTimes': currentStopTimes,
    'currentTrips': currentTrips,
    'allStopTimesForAllTripsWhichGoesThroughCurrentStop': allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    'currentStops': currentStops,
    'currentTripIds': currentTripIds,
  };
}
