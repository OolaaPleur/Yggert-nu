import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobility_app/widgets/map_marker.dart';

import '../../domain/estonia_public_transport/estonia_public_transport.dart';
import '../../domain/vehicle_repository.dart';
import '../../utils/compute_data.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required VehicleRepository vehicleRepository}) : super(const MapState()) {
    on<MapMarkersPlacingOnMap>(_onMapMarkersPlacingOnMap);
    on<MapMarkerFilterButtonPressed>(_onMapMarkerFilterButtonPressed);
    on<MapShowBusStops>(_onMapShowBusStops);
    on<MapCloseStopTimesModalBottomSheet>(_onMapCloseStopTimesModalBottomSheet);
    on<MapChangeTimetableMode>(_onMapChangeTimetableMode);
    on<MapShowTripsForCurrentStop>(_onMapShowTripsForCurrentStop);
    on<MapPressFilterButton>(_onMapPressFilterButton);

    // Used only inside BLoC
    on<MapCalculateCurrentListsForOneStop>(_onMapCalculateCurrentListsForOneStop);
    on<MapLoadTripsForToday>(_onMapLoadTripsForToday);
    on<MapAddValuesForRepaintingTimeTable>(_onMapAddValuesForRepaintingTimeTable);
    on<MapMarkerFiltering>(_onMapMarkerFiltering);
    on<MapSearchByTheQuery>(_onMapSearchByTheQuery);
  }

  VehicleRepository vehicleRepository = VehicleRepository();

  void _onMapChangeTimetableMode(MapChangeTimetableMode event, Emitter<MapState> emit) {
    emit(state.copyWith(globalShowTripsForToday: event.globalShowTripsForToday));
  }

  void _onMapShowTripsForCurrentStop(MapShowTripsForCurrentStop event, Emitter<MapState> emit) {
    emit(state.copyWith(tripStatus: TripStatus.loading, pickedStop: event.currentStop));
    add(const MapCalculateCurrentListsForOneStop());
  }

  void _onMapPressFilterButton(event, Emitter<MapState> emit) {
    if (state.showTripsForToday == ShowTripsForToday.today) {
      emit(
        state.copyWith(
          tripStatus: TripStatus.loading,
          showTripsForToday: ShowTripsForToday.all,
          filteredByUserTrips: state.currentTrips,
        ),
      );
      if (state.query != '') {
        add(MapSearchByTheQuery(state.query));
      } else {
        add(const MapAddValuesForRepaintingTimeTable());
      }
    } else {
      emit(
        state.copyWith(
          tripStatus: TripStatus.loading,
          showTripsForToday: ShowTripsForToday.today,
        ),
      );
      if (state.query != '') {
        add(MapSearchByTheQuery(state.query));
      } else {
        add(const MapLoadTripsForToday());
      }
    }
  }

  Future<void> _onMapCalculateCurrentListsForOneStop(event, Emitter<MapState> emit) async {
    final computeData = ComputeData(
      stopTimes: state.stopTimes,
      busStops: state.busStops,
      vehicleRepository: vehicleRepository,
      trips: state.trips,
      stop: state.pickedStop,
    );
    final processedData = await compute(processData, computeData);
    emit(
      state.copyWith(
        currentStopTimes: processedData['currentStopTimes'] as List<StopTime>,
        currentTrips: processedData['currentTrips'] as List<Trip>,
        filteredByUserTrips: processedData['currentTrips'] as List<Trip>,
        currentTripIds: processedData['currentTripIds'] as List<String>,
        allStopTimesForAllTripsWhichGoesThroughCurrentStop:
            processedData['allStopTimesForAllTripsWhichGoesThroughCurrentStop'] as List<StopTime>,
        currentStops: processedData['currentStops'] as List<Stop>,
        currentsLoaded: true,
        showTripsForToday: state.globalShowTripsForToday == GlobalShowTripsForToday.all
            ? ShowTripsForToday.all
            : ShowTripsForToday.today,
      ),
    );

    if (state.showTripsForToday == ShowTripsForToday.today) {
      add(const MapLoadTripsForToday());
    } else {
      add(const MapAddValuesForRepaintingTimeTable());
    }
  }

  Future<void> _onMapLoadTripsForToday(event, Emitter<MapState> emit) async {
    final todayWeekday = DateFormat.E().format(DateTime.now());
    final timeFormat = DateFormat('HH:mm:ss');
    final currentTimeString = timeFormat.format(DateTime.now());
    final currentTime = timeFormat.parse(currentTimeString);

    final computeData = FilterTripsForToday(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      pickedStop: state.pickedStop,
      calendars: state.calendars,
      vehicleRepository: vehicleRepository,
      todayWeekday: todayWeekday,
      currentTime: currentTime,
    );
    final filteredByUserTripsAfterApplyingToday = await compute(filterTripsForToday, computeData);
    emit(state.copyWith(filteredByUserTrips: filteredByUserTripsAfterApplyingToday));
    add(const MapAddValuesForRepaintingTimeTable());
  }

  Future<void> _onMapAddValuesForRepaintingTimeTable(event, Emitter<MapState> emit) async {
    final computeData = RepaintTimeTable(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      calendars: state.calendars,
      currentStops: state.currentStops,
      pickedStop: state.pickedStop,
      vehicleRepository: vehicleRepository,
    );
    final processedData = await compute(processTrips, computeData);
    log('bloc: ${state.currentStopTimes.length} ${state.trips.length} ${state.currentTrips.length} ${state.filteredByUserTrips.length} '
        '${state.currentTripIds.length} ${state.allStopTimesForAllTripsWhichGoesThroughCurrentStop.length}');
    emit(
      state.copyWith(
        tripStatus: TripStatus.success,
        presentTripStartStopTimes: processedData['presentTripStartStopTimes'] as Map<int, StopTime>,
        presentTripEndStopTimes: processedData['presentTripEndStopTimes'] as Map<int, StopTime>,
        presentTripStartStop: processedData['presentTripStartStop'] as Map<int, Stop>,
        presentTripEndStop: processedData['presentTripEndStop'] as Map<int, Stop>,
        presentStopStopTimeList: processedData['presentStopStopTimeList'] as Map<int, StopTime>,
        presentTripCalendar: processedData['presentTripCalendar'] as Map<int, String>,
      ),
    );
  }

  Future<void> _onMapMarkersPlacingOnMap(event, Emitter<MapState> emit) async {
    final itemsToRemove = <MapMarker>[];
    final stateMarkers = state.markers;
    for (final marker in stateMarkers) {
      if (marker.markerType != MarkerType.busStop) {
        itemsToRemove.add(marker);
      }
    }
    for (final item in itemsToRemove) {
      stateMarkers.remove(item);
    }

    emit(state.copyWith(markers: stateMarkers));

    await vehicleRepository.fetchGtfsData(); // FETCH GTFS DATA
    final scootersLocations = await vehicleRepository.getBoltScooters();
    final bikeLocations = await vehicleRepository.getTartuBikes();
    final mapMarkers = <MapMarker>[...stateMarkers];
    final createMapMarkerList = CreateMapMarkerList();

    for (final bike in bikeLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(bike, this));
    }
    for (final scooter in scootersLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(scooter, this));
    }
    debugPrint(state.markers.length.toString());
    emit(
      state.copyWith(
        status: MapStateStatus.success,
        markers: mapMarkers,
      ),
    );
    add(const MapMarkerFiltering());
  }

  Future<void> _onMapShowBusStops(event, Emitter<MapState> emit) async {
    emit(state.copyWith(busStopAdditionStatus: BusStopAdditionStatus.loading));
    final busStops = await vehicleRepository.parseStops();
    final calendars = await vehicleRepository.parseCalendar();
    final trips = await vehicleRepository.parseTrips(calendars);
    final stopTimes = await vehicleRepository.parseStopTimes(trips);
    final mapMarkers = <MapMarker>[...state.markers];
    log(mapMarkers.length.toString());
    final createMapMarkerList = CreateMapMarkerList();

    for (final busStop in busStops) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
    }
    log('stop times length: ${stopTimes.length} trips length: ${trips.length} stops length: ${busStops.length} '
        'number of stops: ${mapMarkers.length}');

    add(const MapMarkerFiltering());

    emit(
      state.copyWith(
        busStopAdditionStatus: BusStopAdditionStatus.success,
        markers: mapMarkers,
        busStopsAdded: true,
        stopTimes: stopTimes,
        busStops: busStops,
        trips: trips,
        calendars: calendars,
      ),
    );
  }

  ///If empty - when first time fetching info or when spaces/blank query value is written
  ///If not - filter by query
  void _onMapSearchByTheQuery(MapSearchByTheQuery event, Emitter<MapState> emit) {
    emit(state.copyWith(tripStatus: TripStatus.loading));
    if (event.query.trim() != '') {
      final query = event.query.toLowerCase();
      final foundStopInputtedByUser =
          state.currentStops.where((stop) => stop.name.toLowerCase() == query.trim()).toList();
      if (foundStopInputtedByUser.isNotEmpty) {
        var filteredBySequenceStopTimes = <StopTime>[];
        final filteredByUserTrips = <Trip>[];
        final currentStop = state.pickedStop;
        var index = 0;
        log('$query ${currentStop.name} ${state.currentStops.length}');

        final presentStopStopTimeListOnlyFilter = <int, StopTime>{};
        for (final trip in state.currentTrips) {
          final tripStopTimes = state.allStopTimesForAllTripsWhichGoesThroughCurrentStop
              .where((stopTime) => stopTime.tripId == trip.tripId)
              .toList();

          presentStopStopTimeListOnlyFilter[index] = tripStopTimes.firstWhere(
            (stopTime) => stopTime.stopId == currentStop.stopId,
          );

          filteredBySequenceStopTimes = tripStopTimes.sublist(
              presentStopStopTimeListOnlyFilter[index]!
                  .sequence,); //TODO SEARCH FUNCTION AND SHOW STOPTIMES ON PRESSED

          final filteredStopTimes = <StopTime>[]; // USE
          for (final stop in foundStopInputtedByUser) {
            filteredStopTimes.addAll(
              filteredBySequenceStopTimes
                  .where((stopTime) => stopTime.stopId == stop.stopId)
                  .toList(),
            );
          }

          for (final filteredStopTime in filteredStopTimes) {
            for (final stop in foundStopInputtedByUser) {
              if (filteredStopTime.stopId == stop.stopId) {
                filteredByUserTrips.add(trip);
              }
            }
          }
          index += 1;
        }
        emit(
          state.copyWith(filteredByUserTrips: filteredByUserTrips, query: event.query),
        );
        if (state.showTripsForToday == ShowTripsForToday.today) {
          add(const MapLoadTripsForToday());
        } else {
          add(const MapAddValuesForRepaintingTimeTable());
        }
      } else {
        add(const MapPressFilterButton());
      }
    }
  }

  Future<void> _onMapCloseStopTimesModalBottomSheet(event, Emitter<MapState> emit) async {
    debugPrint('clear');
    emit(
      state.copyWith(
        tripStatus: TripStatus.initial,
        query: '',
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
        showTripsForToday: state.globalShowTripsForToday == GlobalShowTripsForToday.all
            ? ShowTripsForToday.all
            : ShowTripsForToday.today,
        currentsLoaded: false,
      ),
    );
  }

  void _onMapMarkerFilterButtonPressed(MapMarkerFilterButtonPressed event, Emitter<MapState> emit) {
    final editedFilters = Map<MapFilters, bool>.from(state.filters);
    editedFilters[event.mapFilter] = !editedFilters[event.mapFilter]!;
    emit(state.copyWith(filters: editedFilters, filteringStatus: true));
    add(const MapMarkerFiltering());
  }

  void _onMapMarkerFiltering(MapMarkerFiltering event, Emitter<MapState> emit) {
    final filteredMarkers = <MapMarker>[];
    var mapMarker = MapMarker(markerType: MarkerType.none);
    for (mapMarker in state.markers) {
      if ((state.filters[MapFilters.busStop]! && mapMarker.markerType == MarkerType.busStop) ||
          (state.filters[MapFilters.cycles]! && mapMarker.markerType == MarkerType.bike) ||
          (state.filters[MapFilters.scooters]! && mapMarker.markerType == MarkerType.scooter)) {
        filteredMarkers.add(mapMarker);
      }
    }
    emit(state.copyWith(filteredMarkers: filteredMarkers, filteringStatus: false));
  }
}
