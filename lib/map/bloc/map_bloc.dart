import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/widgets/map_marker.dart';

import '../../domain/estonia_public_transport/estonia_public_transport.dart';
import '../../domain/vehicle_repository.dart';
import '../../utils/compute_data.dart';

part 'map_event.dart';

part 'map_state.dart';

/// BLoC class, handles [MapEvent]'s and [MapState]
class MapBloc extends Bloc<MapEvent, MapState> {
  /// Constructor for [MapBloc] class.
  MapBloc({required VehicleRepository vehicleRepository})
      : _vehicleRepository = vehicleRepository,
        super(const MapState()) {
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
    on<MapEnlargeIcon>(_onMapEnlargeIcon);
  }

  final VehicleRepository _vehicleRepository;

  void _onMapEnlargeIcon (MapEnlargeIcon event, Emitter<MapState> emit) {
    emit(state.copyWith(keyFromOpenedMarker: event.keyFromOpenedMarker));
  }

  void _onMapChangeTimetableMode(MapChangeTimetableMode event, Emitter<MapState> emit) {
    emit(state.copyWith(globalShowTripsForToday: event.globalShowTripsForToday));
  }

  void _onMapShowTripsForCurrentStop(MapShowTripsForCurrentStop event, Emitter<MapState> emit) {
    emit(state.copyWith(tripStatus: TripStatus.loading, pickedStop: event.currentStop));
    add(const MapCalculateCurrentListsForOneStop());
  }

  void _onMapPressFilterButton(MapPressFilterButton event, Emitter<MapState> emit) {
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

  Future<void> _onMapCalculateCurrentListsForOneStop(
      MapCalculateCurrentListsForOneStop event, Emitter<MapState> emit,) async {
    final computeData = CalculateCurrentListsForOneStop(
      stopTimes: state.stopTimes,
      busStops: state.busStops,
      vehicleRepository: _vehicleRepository,
      trips: state.trips,
      stop: state.pickedStop,
    );
    final processedData = await compute(calculateCurrentListsForOneStop, computeData);
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

  Future<void> _onMapLoadTripsForToday(MapLoadTripsForToday event, Emitter<MapState> emit) async {
    final computeData = FilterTripsForToday(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      pickedStop: state.pickedStop,
      calendars: state.calendars,
      vehicleRepository: _vehicleRepository,
    );
    final filteredByUserTripsAfterApplyingToday = await compute(filterTripsForToday, computeData);
    emit(state.copyWith(filteredByUserTrips: filteredByUserTripsAfterApplyingToday));
    add(const MapAddValuesForRepaintingTimeTable());
  }

  Future<void> _onMapAddValuesForRepaintingTimeTable(
      MapAddValuesForRepaintingTimeTable event, Emitter<MapState> emit,) async {
    final computeData = RepaintTimeTable(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      calendars: state.calendars,
      currentStops: state.currentStops,
      pickedStop: state.pickedStop,
      vehicleRepository: _vehicleRepository,
    );
    final processedData = await compute(repaintTimeTable, computeData);
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

  Future<void> _onMapMarkersPlacingOnMap(MapMarkersPlacingOnMap event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStateStatus.loading));
    final itemsToRemove = <MapMarker>[];
    final stateMarkers = state.markers;
    for (final marker in stateMarkers) {
      if (marker.markerType != MarkerType.stop) {
        itemsToRemove.add(marker);
      }
    }
    for (final item in itemsToRemove) {
      stateMarkers.remove(item);
    }

    emit(state.copyWith(markers: stateMarkers));
    try {
      await _vehicleRepository.fetchGtfsData(); // FETCH GTFS DATA
    } catch (e) {
      emit(state.copyWith(networkException: e.toString().substring(11)));
      emit(state.copyWith(networkException: ''));
    }
    final mapMarkers = <MapMarker>[...stateMarkers];
    final createMapMarkerList = CreateMapMarkerList();
    try {
      final scootersLocations = await _vehicleRepository.getBoltScooters();
      for (final scooter in scootersLocations) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(scooter, this));
      }
    }
    catch (e) {
      emit(state.copyWith(networkException: e.toString().substring(11)));
      emit(state.copyWith(networkException: ''));
    }
    try {
      final bikeLocations = await _vehicleRepository.getTartuBikes();
      for (final bike in bikeLocations) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(bike, this));
      }
    }
    catch (e) {
      emit(state.copyWith(networkException: e.toString().substring(11)));
      emit(state.copyWith(networkException: ''));
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

  Future<void> _onMapShowBusStops(MapShowBusStops event, Emitter<MapState> emit) async {
    if (await _vehicleRepository.checkFileExistence() == true) {
      emit(state.copyWith(busStopAdditionStatus: BusStopAdditionStatus.loading));
      final busStops = await _vehicleRepository.parseStops();
      final calendars = await _vehicleRepository.parseCalendar();
      final trips = await _vehicleRepository.parseTrips(calendars);
      final stopTimes = await _vehicleRepository.parseStopTimes(trips);
      final mapMarkers = <MapMarker>[...state.markers];
      log(mapMarkers.length.toString());
      final createMapMarkerList = CreateMapMarkerList();

      for (final busStop in busStops) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
      }
      log('stop times length: ${stopTimes.length} trips length: ${trips
          .length} stops length: ${busStops.length} '
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
    } else {
      emit(state.copyWith(networkException: 'No file is present, press refresh button to download'));
      emit(state.copyWith(networkException: ''));
    }
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
            presentStopStopTimeListOnlyFilter[index]!.sequence,
          ); //TODO SEARCH FUNCTION AND SHOW STOPTIMES ON PRESSED

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

  Future<void> _onMapCloseStopTimesModalBottomSheet(MapCloseStopTimesModalBottomSheet event, Emitter<MapState> emit) async {
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
      if ((state.filters[MapFilters.busStop]! && mapMarker.markerType == MarkerType.stop) ||
          (state.filters[MapFilters.cycles]! && mapMarker.markerType == MarkerType.bike) ||
          (state.filters[MapFilters.scooters]! && mapMarker.markerType == MarkerType.scooter)) {
        filteredMarkers.add(mapMarker);
      }
    }
    emit(state.copyWith(filteredMarkers: filteredMarkers, filteringStatus: false));
  }
}
