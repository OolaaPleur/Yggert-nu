import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobility_app/widgets/map_marker.dart';

import '../../domain/estonia_public_transport/estonia_public_transport.dart';
import '../../domain/vehicle_repository.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required VehicleRepository vehicleRepository}) : super(const MapState()) {
    on<MapMarkersPlacingOnMap>(_onMapMarkersPlacingOnMap);
    on<MapFilteringMarkers>(_onMapFilteringMarkers);
    on<MapShowBusStops>(_onMapShowBusStops);
    on<MapCloseStopTimesModalBottomSheet>(_onMapCloseStopTimesModalBottomSheet);
    on<MapGetTripsForStopTimesForOneStop>(_onMapGetTripsForStopTimesForOneStop);
    on<MapShowTripsForToday>(_onMapShowTripsForToday);
  }

  Future<void> _onMapMarkersPlacingOnMap(event, emit) async {
    var itemsToRemove = [];
    List<MapMarker> stateMarkers = state.markers;
    for (final marker in stateMarkers) {
      if (marker.markerType != MarkerType.busStop) {
        itemsToRemove.add(marker);
      }
    }
    for (var item in itemsToRemove) {
      stateMarkers.remove(item);
    }

    emit(state.copyWith(markers: stateMarkers));

    VehicleRepository vehicleRepository = VehicleRepository();
    await vehicleRepository.fetchGtfsData(); // FETCH GTFS DATA
    final scootersLocations = await vehicleRepository.getBoltScooters();
    final bikeLocations = await vehicleRepository.getTartuBikes();
    List<MapMarker> mapMarkers = [];
    mapMarkers.addAll(stateMarkers);
    CreateMapMarkerList createMapMarkerList = CreateMapMarkerList();

    for (final bike in bikeLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(bike, this));
    }
    for (final scooter in scootersLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(scooter, this));
    }
    debugPrint(state.markers.length.toString());
    emit(state.copyWith(
      status: MapStateStatus.success,
      markers: mapMarkers,
    ));
    add(MapFilteringMarkers({
      MapFilters.cycles: state.filters[MapFilters.cycles]!,
      MapFilters.scooters: state.filters[MapFilters.scooters]!,
      MapFilters.busStop: state.filters[MapFilters.busStop]!
    }));
  }

  Future<void> _onMapShowBusStops(event, emit) async {
    emit(state.copyWith(busStopAdditionStatus: BusStopAdditionStatus.loading));
    VehicleRepository vehicleRepository = VehicleRepository();
    final busStops = await vehicleRepository.parseStops();
    final stopTimes = await vehicleRepository.parseStopTimes();
    final calendars = await vehicleRepository.parseCalendar();
    log('stop times length: ${stopTimes.length}');
    final trips = await vehicleRepository.parseTrips();
    List<MapMarker> mapMarkers = state.markers;
    CreateMapMarkerList createMapMarkerList = CreateMapMarkerList();

    for (final busStop in busStops) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
    }
    debugPrint('Number of stops: ${mapMarkers.length.toString()}');

    emit(
      state.copyWith(
          status: MapStateStatus.success,
          busStopAdditionStatus: BusStopAdditionStatus.success,
          markers: mapMarkers,
          busStopsAdded: true,
          stopTimes: stopTimes,
          busStops: busStops,
          trips: trips,
          calendars: calendars),
    );
  }

  Future<void> _onMapShowTripsForToday(event, emit) async {
    if (state.showTripsForToday == ShowTripsForToday.initial) {
      emit(
        state.copyWith(showTripsForToday: ShowTripsForToday.loadingForToday),
      );
    } else if (state.showTripsForToday == ShowTripsForToday.success) {
      emit(
        state.copyWith(showTripsForToday: ShowTripsForToday.loadingForAllWeekdays),
      );
    }
    log(state.showTripsForToday as String);
    add(MapGetTripsForStopTimesForOneStop('', state.pickedStop));
  }

  Future<void> _onMapGetTripsForStopTimesForOneStop(event, emit) async {
    emit(state.copyWith(tripStatus: TripStatus.loading));
    VehicleRepository vehicleRepository = VehicleRepository();
    //await Future.delayed(Duration(milliseconds: 3000));
    List<StopTime> currentStopTimes =
        await vehicleRepository.getStopTimesForOneStop(event.currentStop.stopId, state.stopTimes);
    List<Trip> currentTrips = await vehicleRepository.getTripsForOneStopForAllStopTimes(currentStopTimes, state.trips);

    emit(state.copyWith(currentStopTimes: currentStopTimes, currentTrips: currentTrips, pickedStop: event.currentStop));

    List<Trip> filteredByUserTrips = currentTrips;

    // If empty - when first time fetching info or when spaces/blank query value is written
    // If not - filter by query
    if (event.query.trim() != '') {
      String query = event.query;
      List<Stop> foundStopInputtedByUser = state.currentStops.where((stop) => stop.name == query.trim()).toList();
      if (foundStopInputtedByUser.isNotEmpty) {
        List<StopTime> filteredBySequenceStopTimes = [];
        filteredByUserTrips = [];
        Stop currentStop = event.currentStop;
        int index = 0;
        log('$query ${currentStop.name} ${state.currentStops.length}');

        Map<int, StopTime> presentStopStopTimeListOnlyFilter = {};
        for (final trip in currentTrips) {
          final tripStopTimes =
              state.stopTimes // TODO CHANGE TO allStopTimesForAllTripsWhichGoesThroughCurrentStop IF POSSIBLE
                  .where((stopTime) => stopTime.tripId == trip.tripId)
                  .toList();

          presentStopStopTimeListOnlyFilter[index] = tripStopTimes.firstWhere(
              (stopTime) => stopTime.stopId == currentStop.stopId,
              orElse: () => StopTime(tripId: '', stopId: '', arrivalTime: '', departureTime: '', sequence: 0));

          filteredBySequenceStopTimes =
              tripStopTimes.sublist(presentStopStopTimeListOnlyFilter[index]!.sequence); //TODO SEARCH FUNCTION

          List<StopTime> filteredStopTimes = [];
          for (var stop in foundStopInputtedByUser) {
            filteredStopTimes.addAll(
              filteredBySequenceStopTimes.where((stopTime) => stopTime.stopId == stop.stopId).toList(),
            );
          }

          for (var filteredStopTime in filteredStopTimes) {
            for (var stop in foundStopInputtedByUser) {
              if (filteredStopTime.stopId == stop.stopId) {
                filteredByUserTrips.add(trip);
              }
            }
          }
          index += 1;
        }
      } else {
        filteredByUserTrips = [];
      }
    }

    String todayWeekday = DateFormat.E().format(DateTime.now());
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final String currentTimeString = timeFormat.format(DateTime.now());
    final DateTime currentTime = timeFormat.parse(currentTimeString);
    List<Trip> filteredByUserTripsAfterApplyingToday = [];
    if (state.showTripsForToday == ShowTripsForToday.loadingForToday) {
      bool tripWillBeToday = false;
      for (final trip in filteredByUserTrips) {
        final tripStopTimes =
        state.stopTimes // TODO CHANGE TO allStopTimesForAllTripsWhichGoesThroughCurrentStop IF POSSIBLE
            .where((stopTime) => stopTime.tripId == trip.tripId)
            .toList();
        for (final stopTime in tripStopTimes) {
          if ((timeFormat.parse(stopTime.departureTime).isAfter(currentTime)) && stopTime.stopId == state.pickedStop.stopId) {
            tripWillBeToday = true;
            break;
          }
        }
        final tripCalendars = vehicleRepository.getCalendarForService(trip.serviceId, state.calendars);
        String stringOfWeekdays = vehicleRepository.getDaysOfWeekString(tripCalendars);
        if (stringOfWeekdays.contains(todayWeekday) && tripWillBeToday) {
          filteredByUserTripsAfterApplyingToday.add(trip);
          tripWillBeToday = false;
        }
      }
      filteredByUserTrips = [];
      filteredByUserTrips = filteredByUserTripsAfterApplyingToday;
      log(filteredByUserTrips.length as String);
    }



    currentStopTimes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    filteredByUserTrips.sort((a, b) {
      int indexA =
      currentStopTimes.indexWhere((stopTime) => stopTime.tripId == a.tripId);
      int indexB =
      currentStopTimes.indexWhere((stopTime) => stopTime.tripId == b.tripId);
      return indexA.compareTo(indexB);
    });

    final tripIds = filteredByUserTrips.map((trip) => trip.tripId).toList(); // TODO MOVE TO STATE
    final allStopTimesForAllTripsWhichGoesThroughCurrentStop =
        state.stopTimes.where((stopTime) => tripIds.contains(stopTime.tripId)).toList(); // TODO MOVE TO STATE

    // getting list of unique stopIds from StopTimes
    Set<String> stopIds = allStopTimesForAllTripsWhichGoesThroughCurrentStop.map((stopTime) => stopTime.stopId).toSet();

    // filtering Stops based on the stopIds
    List<Stop> currentStops = state.busStops.where((stop) => stopIds.contains(stop.stopId)).toList();

    Map<int, StopTime> presentStopStopTimeList = {};

    Map<int, StopTime> presentTripStartStopTimes = {};
    Map<int, StopTime> presentTripEndStopTimes = {};
    Map<int, Stop> presentTripStartStop = {};
    Map<int, Stop> presentTripEndStop = {};
    Map<int, String> presentTripCalendar = {};

    int indexForAll = 0;
    for (final trip in filteredByUserTrips) {
      final tripStopTimes =
          state.stopTimes // TODO CHANGE TO allStopTimesForAllTripsWhichGoesThroughCurrentStop IF POSSIBLE
              .where((stopTime) => stopTime.tripId == trip.tripId)
              .toList();
      final tripCalendars = vehicleRepository.getCalendarForService(trip.serviceId, state.calendars);
      presentTripCalendar[indexForAll] = vehicleRepository.getDaysOfWeekString(tripCalendars);

      presentTripStartStopTimes[indexForAll] = tripStopTimes.firstWhere((stopTime) => stopTime.sequence == 1);
      presentTripEndStopTimes[indexForAll] =
          tripStopTimes.lastWhere((stopTime) => stopTime.sequence == tripStopTimes.length);
      presentTripStartStop[indexForAll] =
          currentStops.firstWhere((stop) => stop.stopId == presentTripStartStopTimes[indexForAll]!.stopId);
      presentTripEndStop[indexForAll] =
          currentStops.firstWhere((stop) => stop.stopId == presentTripEndStopTimes[indexForAll]!.stopId);

      presentStopStopTimeList[indexForAll] = tripStopTimes.firstWhere(
          (stopTime) => stopTime.stopId == state.pickedStop.stopId,
          orElse: () => StopTime(tripId: '', stopId: '', arrivalTime: '', departureTime: '', sequence: 0));

      indexForAll += 1;
    }

    log(
        'bloc: ${state.currentStopTimes.length} ${state.trips.length} ${currentTrips.length} ${filteredByUserTrips.length} '
        '${tripIds.length} ${allStopTimesForAllTripsWhichGoesThroughCurrentStop.length}');
    emit(
      state.copyWith(
          currentTrips: currentTrips,
          tripStatus: TripStatus.success,
          currentTripIds: tripIds,
          allStopTimesForAllTripsWhichGoesThroughCurrentStop: allStopTimesForAllTripsWhichGoesThroughCurrentStop,
          currentStops: currentStops,
          presentTripStartStopTimes: presentTripStartStopTimes,
          presentTripEndStopTimes: presentTripEndStopTimes,
          presentTripStartStop: presentTripStartStop,
          presentTripEndStop: presentTripEndStop,
          presentStopStopTimeList: presentStopStopTimeList,
          filteredByUserTrips: filteredByUserTrips,
          presentTripCalendar: presentTripCalendar,
          showTripsForToday: state.showTripsForToday == ShowTripsForToday.loadingForToday
              ? ShowTripsForToday.success
              : ShowTripsForToday.initial),
    );
  }

  Future<void> _onMapCloseStopTimesModalBottomSheet(event, emit) async {
    debugPrint('clear');
    emit(state.copyWith(
        tripStatus: TripStatus.initial,
        pickedStop: const Stop(),
        currentStopTimes: [],
        currentTrips: [],
        currentTripIds: [],
        allStopTimesForAllTripsWhichGoesThroughCurrentStop: [],
        currentStops: [],
        presentTripStartStopTimes: {},
        presentTripEndStopTimes: {},
        presentTripStartStop: {},
        presentTripEndStop: {},
        presentStopStopTimeList: {},
        filteredByUserTrips: [],
        showTripsForToday: ShowTripsForToday.initial));
  }

  Future<void> _onMapFilteringMarkers(event, emit) async {
    emit(state.copyWith(filters: event.filters));
    List<MapMarker> filteredMarkers = [];
    MapMarker mapMarker = MapMarker(markerType: MarkerType.none);
    for (mapMarker in state.markers) {
      if ((state.filters[MapFilters.busStop] as bool && mapMarker.markerType == MarkerType.busStop) ||
          (state.filters[MapFilters.cycles] as bool && mapMarker.markerType == MarkerType.bike) ||
          (state.filters[MapFilters.scooters] as bool && mapMarker.markerType == MarkerType.scooter)) {
        filteredMarkers.add(mapMarker);
      }
    }
    emit(state.copyWith(filteredMarkers: filteredMarkers));
  }
}
