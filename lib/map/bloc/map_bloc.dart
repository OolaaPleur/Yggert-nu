import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/widgets/map_marker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    on<MapLoadTripsForToday>(_onMapLoadTripsForToday);
    on<MapAddValuesForRepaintingTimeTable>(_onMapAddValuesForRepaintingTimeTable);
    on<MapMarkerFiltering>(_onMapMarkerFiltering);
    on<MapSearchByTheQuery>(_onMapSearchByTheQuery);
    on<MapEnlargeIcon>(_onMapEnlargeIcon);
    on<MapPressTheTripButton>(_onMapPressTheTripButton);
  }

  final VehicleRepository _vehicleRepository;

  void _onMapEnlargeIcon(MapEnlargeIcon event, Emitter<MapState> emit) {
    emit(state.copyWith(keyFromOpenedMarker: event.keyFromOpenedMarker));
  }

  void _onMapChangeTimetableMode(MapChangeTimetableMode event, Emitter<MapState> emit) {
    _vehicleRepository.saveValue(event.globalShowTripsForToday.name);
    print(event.globalShowTripsForToday.name);
    emit(state.copyWith(globalShowTripsForToday: event.globalShowTripsForToday));
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

  Future<void> _onMapShowTripsForCurrentStop(
    MapShowTripsForCurrentStop event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(tripStatus: TripStatus.loading, pickedStop: event.currentStop));
    final dbPath = await getDatabasesPath();
    final stopTimesDb = await openDatabase(join(dbPath, 'stop_times.db'));
    final tripsDb = await openDatabase(join(dbPath, 'trips.db'));

    final currentStopTimesMaps = await stopTimesDb
        .query('stopTimes', where: 'stopId = ?', whereArgs: [state.pickedStop.stopId]);
    final currentStopTimes = currentStopTimesMaps.map(StopTime.fromMap).toList();

    final tripIds = currentStopTimes.map((stopTime) => stopTime.tripId).toList();
    final placeholders = List<String>.filled(tripIds.length, '?').join(', ');
    final currentTripsMaps = await tripsDb.query(
      'trips',
      where: 'tripId IN ($placeholders)',
      whereArgs: tripIds,
    );

    final currentTrips = currentTripsMaps.map(Trip.fromMap).toList();

    currentStopTimes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

    currentTrips.sort((a, b) {
      final indexA = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == a.tripId);
      final indexB = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == b.tripId);
      return indexA.compareTo(indexB);
    });

    final currentTripIds = currentTrips.map((trip) => trip.tripId).toList();

    final placeholdersD = List<String>.filled(currentTripIds.length, '?').join(', ');
    final allStopTimesForAllTripsWhichGoesThroughCurrentStopMaps = await stopTimesDb.query(
      'stopTimes',
      where: 'tripId IN ($placeholdersD)',
      whereArgs: currentTripIds,
    );
    final allStopTimesForAllTripsWhichGoesThroughCurrentStop =
        allStopTimesForAllTripsWhichGoesThroughCurrentStopMaps
            .map(StopTime.fromMap)
            .toList();

    // getting list of unique stopIds from StopTimes
    final stopIds = allStopTimesForAllTripsWhichGoesThroughCurrentStop
        .map((stopTime) => stopTime.stopId)
        .toSet();
    final currentStops = state.busStops.where((stop) => stopIds.contains(stop.stopId)).toList();
    await stopTimesDb.close();
    await tripsDb.close();
    // log('early: ${currentStopTimes.length} ${currentTrips.length} ${state.filteredByUserTrips.length} '
    //     '${currentTripIds.length} ${allStopTimesForAllTripsWhichGoesThroughCurrentStop.length} ${currentStopTimes.first.departureTime}');
    // int stopTimesCount = await countEntries('stop_times', 'stopTimes');
    // print('Number of entries in stopTimes table: $stopTimesCount');
    //
    // int tripsCount = await countEntries('trips', 'trips');
    // print('Number of entries in trips table: $tripsCount');
    emit(
      state.copyWith(
        currentStopTimes: currentStopTimes,
        currentTrips: currentTrips,
        filteredByUserTrips: currentTrips,
        currentTripIds: currentTripIds,
        allStopTimesForAllTripsWhichGoesThroughCurrentStop:
            allStopTimesForAllTripsWhichGoesThroughCurrentStop,
        currentStops: currentStops,
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

  // Future<int> countEntries(String dbName, String tableName) async {
  //   final dbPath = await getDatabasesPath();
  //   final db = await openDatabase(join(dbPath, '$dbName.db'));
  //   final countMap = await db.rawQuery('SELECT COUNT(*) AS count FROM $tableName');
  //   final count = countMap.first['count'] as int;
  //   await db.close();
  //   return count;
  // }

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
    MapAddValuesForRepaintingTimeTable event,
    Emitter<MapState> emit,
  ) async {
    final computeData = RepaintTimeTable(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      calendars: state.calendars,
      currentStops: state.currentStops,
      pickedStop: state.pickedStop,
      vehicleRepository: _vehicleRepository,
    );
    log('early bloc: ${state.currentStopTimes.length} ${state.currentTrips.length} ${state.filteredByUserTrips.length} '
        '${state.currentTripIds.length} ${state.allStopTimesForAllTripsWhichGoesThroughCurrentStop.length}');
    final processedData = await compute(repaintTimeTable, computeData);
    log('bloc: ${state.currentStopTimes.length} ${state.currentTrips.length} ${state.filteredByUserTrips.length} '
        '${state.currentTripIds.length} ${state.allStopTimesForAllTripsWhichGoesThroughCurrentStop.length}');
    final dbPath = await getDatabasesPath();
    final routesDb = await openDatabase(join(dbPath, 'routes.db'));

    var count = 0;
    final presentRoutes = <int, Route>{};
    for (final trip in state.filteredByUserTrips) {
      final maps = await routesDb.query(
        'Routes',
        where: 'route_id = ?',
        whereArgs: [trip.routeId],
      );
      presentRoutes[count] = Route.fromMap(maps.first);
      count++;
    }
    final pressedButtonOnTrip = List.filled(state.filteredByUserTrips.length, false);
    await routesDb.close();
    emit(
      state.copyWith(
        tripStatus: TripStatus.success,
        presentTripStartStopTimes: processedData['presentTripStartStopTimes'] as Map<int, StopTime>,
        presentTripEndStopTimes: processedData['presentTripEndStopTimes'] as Map<int, StopTime>,
        presentTripStartStop: processedData['presentTripStartStop'] as Map<int, Stop>,
        presentTripEndStop: processedData['presentTripEndStop'] as Map<int, Stop>,
        presentStopStopTimeList: processedData['presentStopStopTimeList'] as Map<int, StopTime>,
        presentTripCalendar: processedData['presentTripCalendar'] as Map<int, String>,
        presentStopStopTimeListOnlyFilter:
            processedData['presentStopStopTimeListOnlyFilter'] as Map<int, List<StopTime>>,
        presentStopListOnlyFilter:
            processedData['presentStopListOnlyFilter'] as Map<int, List<Stop>>,
        presentRoutes: presentRoutes,
        pressedButtonOnTrip: pressedButtonOnTrip,
          presentStopsInForwardDirection: processedData['presentStopsInForwardDirection'] as List<Stop>,
      ),
    );
  }

  Future<void> _onMapMarkersPlacingOnMap(
    MapMarkersPlacingOnMap event,
    Emitter<MapState> emit,
  ) async {
    final globalShowTripsForToday = await _vehicleRepository.getValue();
    if (globalShowTripsForToday == 'all') {
      emit(state.copyWith(globalShowTripsForToday: GlobalShowTripsForToday.all));
    } else {
      emit(state.copyWith(globalShowTripsForToday: GlobalShowTripsForToday.today));
    }

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
      emit(state.copyWith(networkException: {e.toString().substring(11): []}));
      emit(state.copyWith(networkException: <String, List<String>>{}));
    }
    final mapMarkers = <MapMarker>[...stateMarkers];
    final createMapMarkerList = CreateMapMarkerList();
    try {
      final scootersLocations = await _vehicleRepository.getBoltScooters();
      for (final scooter in scootersLocations) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(scooter, this));
      }
    } catch (e) {
      emit(state.copyWith(networkException: {e.toString().substring(11): ['Bolt', 'scooters']}));
      emit(state.copyWith(networkException: <String, List<String>>{}));
    }
    try {
      final bikeLocations = await _vehicleRepository.getTartuBikes();
      for (final bike in bikeLocations) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(bike, this));
      }
    } catch (e) {
      emit(state.copyWith(networkException: {e.toString().substring(11): ['Tartu', 'bikes']}));
      emit(state.copyWith(networkException: <String, List<String>>{}));
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
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.loading,
        ),
      );
      final busStops = await _vehicleRepository.parseStops();
      final calendars = await _vehicleRepository.parseCalendar();
      await _vehicleRepository.parseTrips(calendars);
      await _vehicleRepository.parseStopTimes();
      await _vehicleRepository.parseRoutes();
      final mapMarkers = <MapMarker>[...state.markers];
      log(mapMarkers.length.toString());
      final createMapMarkerList = CreateMapMarkerList();

      for (final busStop in busStops) {
        mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
      }
      log('stops length: [] trips length: [] stops length: ${busStops.length} '
          'number of stops: ${mapMarkers.length}');

      add(const MapMarkerFiltering());

      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.success,
          markers: mapMarkers,
          busStopsAdded: true,
          //stopTimes: stopTimes,
          busStops: busStops,
          //trips: trips,
          calendars: calendars,
        ),
      );
    } else {
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.failure,
          networkException: {'No file is present, press refresh button to download' : []},
        ),
      );
      emit(state.copyWith(networkException: <String, List<String>>{}));
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

  void _onMapPressTheTripButton(MapPressTheTripButton event, Emitter<MapState> emit) {
    final pressedButtonOnTrip = state.pressedButtonOnTrip;
    pressedButtonOnTrip[event.pressedTrip] = !pressedButtonOnTrip[event.pressedTrip];

    emit(state.copyWith(pressedButtonOnTrip: pressedButtonOnTrip));
  }

  Future<void> _onMapCloseStopTimesModalBottomSheet(
    MapCloseStopTimesModalBottomSheet event,
    Emitter<MapState> emit,
  ) async {
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
        pressedButtonOnTrip: [],
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
