import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mobility_app/data/repositories/public_transport_repository.dart';
import 'package:mobility_app/utils/database/database_operations.dart';
import 'package:mobility_app/utils/io/io_operations.dart';

import '../../../constants/constants.dart';
import '../../../data/models/bolt_scooter.dart';
import '../../../data/models/estonia_public_transport.dart';
import '../../../data/models/tartu_bike_station.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../domain/usecases/filter_trips_by_direction.dart';
import '../../../domain/usecases/get_calendar.dart';
import '../../../domain/usecases/get_stops.dart';
import '../../../exceptions/exceptions.dart';
import '../../../utils/gtfs_list_operations.dart';
import '../markers/map_marker.dart';

part 'map_event.dart';

part 'map_state.dart';

/// BLoC class, handles [MapEvent]'s and [MapState]
class MapBloc extends Bloc<MapEvent, MapState> {
  /// Constructor for [MapBloc] class.
  MapBloc()
      : _vehicleRepository = GetIt.I<VehicleRepository>(),
        _settingsRepository = GetIt.I<SettingsRepository>(),
        _getStops = GetIt.I<GetStops>(),
        _getCalendar = GetIt.I<GetCalendar>(),
        _filterTripsByDirection = GetIt.I<FilterTripsByDirection>(),
        _publicTransportRepository = GetIt.I<PublicTransportRepository>(),
        _createMapMarkerList = GetIt.I<CreateMapMarkerList>(),
        super(const MapState()) {
    on<MapMarkersPlacingOnMap>(_onMapMarkersPlacingOnMap);
    on<MapMarkerFilterButtonPressed>(_onMapMarkerFilterButtonPressed);
    on<MapShowBusStops>(_onMapShowBusStops);
    on<MapCloseStopTimesModalBottomSheet>(_onMapCloseStopTimesModalBottomSheet);
    on<MapChangeTimetableMode>(_onMapChangeTimetableMode);
    on<MapShowTripsForCurrentStop>(_onMapShowTripsForCurrentStop);
    on<MapPressFilterButton>(_onMapPressFilterButton);
    on<MapPressFilterByDirectionButton>(_onMapPressFilterByDirectionButton);
    on<MapChangeCity>(_onMapChangeCity);
    on<MapSearchByTheQuery>(_onMapSearchByTheQuery);
    on<MapGetSingleBikeStationInfo>(_onMapGetSingleBikeStationInfo);

    // Used only inside BLoC
    on<_MapLoadTripsForToday>(_onMapLoadTripsForToday);
    on<_MapAddValuesForRepaintingTimeTable>(_onMapAddValuesForRepaintingTimeTable);
    on<_MapMarkerFiltering>(_onMapMarkerFiltering);
    on<MapEnlargeIcon>(_onMapEnlargeIcon);
    on<MapPressTheTripButton>(_onMapPressTheTripButton);
    on<_MapFilterTripsByDirection>(_onMapFilterTripsByDirection);
    on<_MapShowTodayOrAllTrips>(_onMapShowTodayOrAllTrips);
    on<MapDeleteSingleBikeStationInfo>(_onMapDeleteSingleBikeStationInfo);
    on<_MapAddMicroMobilityMarkersToList>(_onMapAddMicroMobilityMarkersToList);
  }

  final VehicleRepository _vehicleRepository;
  final SettingsRepository _settingsRepository;
  final GetStops _getStops;
  final GetCalendar _getCalendar;
  final FilterTripsByDirection _filterTripsByDirection;
  final PublicTransportRepository _publicTransportRepository;
  final CreateMapMarkerList _createMapMarkerList;

  final _log = Logger('EstoniaPublicTransportApiProvider');

  void _onMapDeleteSingleBikeStationInfo(
    MapDeleteSingleBikeStationInfo event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(singleBikeStation: []));
  }

  Future<void> _onMapGetSingleBikeStationInfo(
    MapGetSingleBikeStationInfo event,
    Emitter<MapState> emit,
  ) async {
    final singleBikeStation = await _vehicleRepository.getBikeInfo(event.bikeId);
    emit(state.copyWith(singleBikeStation: [singleBikeStation]));
  }

  void _onMapEnlargeIcon(MapEnlargeIcon event, Emitter<MapState> emit) {
    emit(state.copyWith(keyFromOpenedMarker: event.keyFromOpenedMarker));
  }

  void _onMapChangeTimetableMode(MapChangeTimetableMode event, Emitter<MapState> emit) {
    _settingsRepository.setStringValue('userTripsFilterValue', event.globalShowTripsForToday.name);
    emit(state.copyWith(globalShowTripsForToday: event.globalShowTripsForToday));
  }

  void _onMapChangeCity(MapChangeCity event, Emitter<MapState> emit) {
    _settingsRepository.setStringValue('pickedCity', event.pickedCity.name);
    emit(state.copyWith(pickedCity: event.pickedCity));
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
        add(const MapPressFilterByDirectionButton(''));
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
        add(const MapPressFilterByDirectionButton(''));
      }
    }
  }

  Future<void> _onMapShowTripsForCurrentStop(
    MapShowTripsForCurrentStop event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(tripStatus: TripStatus.loading, pickedStop: event.currentStop));
    final currentStopTimes =
        await _publicTransportRepository.getCurrentStopTimes(state.pickedStop.stopId);
    final currentTripIds = currentStopTimes.map((stopTime) => stopTime.tripId).toList();
    final currentTrips =
        await _publicTransportRepository.getCurrentTrips(currentStopTimes, currentTripIds);

    final allStopTimesForAllTripsWhichGoesThroughCurrentStop = await _publicTransportRepository
        .getAllStopTimesForAllTripsWhichGoesThroughCurrentStop(currentTripIds);

    // getting list of unique stopIds from StopTimes
    final stopIds = allStopTimesForAllTripsWhichGoesThroughCurrentStop
        .map((stopTime) => stopTime.stopId)
        .toSet();

    final currentStops = state.busStops.where((stop) => stopIds.contains(stop.stopId)).toList();

    final uniqueDirectionIdEndings =
        _publicTransportRepository.getUniqueDirectionIdEndings(currentTrips);
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
        directionChars: uniqueDirectionIdEndings,
      ),
    );
    add(const _MapShowTodayOrAllTrips());
  }

  Future<void> _onMapLoadTripsForToday(_MapLoadTripsForToday event, Emitter<MapState> emit) async {
    final computeData = FilterTripsForToday(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      pickedStop: state.pickedStop,
      calendars: state.calendars,
    );
    final filteredByUserTripsAfterApplyingToday = await compute(filterTripsForToday, computeData);
    emit(state.copyWith(filteredByUserTrips: filteredByUserTripsAfterApplyingToday));
    add(const _MapAddValuesForRepaintingTimeTable());
  }

  Future<void> _onMapAddValuesForRepaintingTimeTable(
    _MapAddValuesForRepaintingTimeTable event,
    Emitter<MapState> emit,
  ) async {
    final computeData = RepaintTimeTable(
      filteredByUserTrips: state.filteredByUserTrips,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          state.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      calendars: state.calendars,
      currentStops: state.currentStops,
      pickedStop: state.pickedStop,
    );
    final processedData = await compute(repaintTimeTable, computeData);
    final routesDb = await DatabaseOperations.openAppDatabase('gtfs');
    var count = 0;
    final presentRoutes = <int, Route>{};

    for (final trip in state.filteredByUserTrips) {
      final maps = await routesDb.query(
        'routes',
        where: 'route_id = ?',
        whereArgs: [trip.routeId],
      );
      presentRoutes[count] = Route.fromMap(maps.first);
      count++;
    }
    final pressedButtonOnTrip = List.filled(state.filteredByUserTrips.length, false);
    await DatabaseOperations.closeDatabase(routesDb);
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
        presentStopsInForwardDirection:
            processedData['presentStopsInForwardDirection'] as List<Stop>,
        presentRoutes: presentRoutes,
        pressedButtonOnTrip: pressedButtonOnTrip,
      ),
    );
    _log.fine(
        'bloc: ${state.currentStopTimes.length} ${state.currentTrips.length} ${state.filteredByUserTrips.length} '
        '${state.currentTripIds.length} ${state.allStopTimesForAllTripsWhichGoesThroughCurrentStop.length}');
  }

  Future<void> _onMapMarkersPlacingOnMap(
    MapMarkersPlacingOnMap event,
    Emitter<MapState> emit,
  ) async {
    final globalShowTripsForToday =
        await _settingsRepository.getStringValue('userTripsFilterValue');
    if (globalShowTripsForToday == 'all') {
      emit(
        state.copyWith(
          globalShowTripsForToday: GlobalShowTripsForToday.all,
          status: MapStateStatus.loading,
        ),
      );
    } else {
      emit(
        state.copyWith(
          globalShowTripsForToday: GlobalShowTripsForToday.today,
          status: MapStateStatus.loading,
        ),
      );
    }

    final stateMarkers = _publicTransportRepository.getOnlyStopsMarkers(state.markers);
    emit(state.copyWith(markers: stateMarkers));
    try {
      final snackbarNoNeedToDownload = await _vehicleRepository.fetchGtfsData(); // FETCH GTFS DATA
      if (snackbarNoNeedToDownload != InfoMessage.noNeedToDownload) {
        emit(
          state.copyWith(
            publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.initial,
            markers: [],
            busStopsAdded: false,
            busStops: [],
            calendars: [],
            filteredMarkers: [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            infoMessage: InfoMessage.noNeedToDownload,
          ),
        );
      }
    } catch (e) {
      _log.severe(e.toString());
    }
    add(const _MapAddMicroMobilityMarkersToList());
    add(const _MapMarkerFiltering());
    emit(
      state.copyWith(
        status: MapStateStatus.success,
      ),
    );
  }

  Future<void> _onMapAddMicroMobilityMarkersToList(
    _MapAddMicroMobilityMarkersToList event,
    Emitter<MapState> emit,
  ) async {
    final mapMarkers = <MapMarker>[...state.markers];
    final pickedCity = await _settingsRepository.getStringValue('pickedCity');
    try {
      List<BoltScooter> scootersLocations;
      if (pickedCity == City.tartu.name) {
        emit(state.copyWith(pickedCity: City.tartu));
        scootersLocations = await _vehicleRepository.getBoltScooters(City.tartu.name);
      } else if (pickedCity == City.tallinn.name) {
        emit(state.copyWith(pickedCity: City.tallinn));
        scootersLocations = await _vehicleRepository.getBoltScooters(City.tallinn.name);
      } else {
        throw const CityIsNotPicked();
      }
      for (final scooter in scootersLocations) {
        mapMarkers.add(_createMapMarkerList.mapMarkerMakeMarkers(scooter, this));
      }
    } catch (e) {
      if (e.runtimeType == CantFetchBoltScootersData) {
        emit(state.copyWith(exception: const CantFetchBoltScootersData()));
      }
      if (e.runtimeType == NoInternetConnection) {
        emit(state.copyWith(exception: const NoInternetConnection()));
      }
      if (e.runtimeType == CityIsNotPicked) {
        emit(state.copyWith(exception: const CityIsNotPicked()));
      }
    }
    if (pickedCity == City.tartu.name) {
      try {
        final bikeLocations = await _vehicleRepository.getTartuBikes();
        for (final bike in bikeLocations) {
          mapMarkers.add(_createMapMarkerList.mapMarkerMakeMarkers(bike, this));
        }
      } catch (e) {
        if (e.runtimeType == CantFetchTartuSmartBikeData) {
          emit(state.copyWith(exception: const CantFetchTartuSmartBikeData()));
        }
        if (e.runtimeType == NoInternetConnection) {
          emit(state.copyWith(exception: const NoInternetConnection()));
        }
        if (e.runtimeType == DeviceIsNotSupported) {
          emit(state.copyWith(exception: const DeviceIsNotSupported()));
        }
      }
    }
    emit(
      state.copyWith(
        markers: mapMarkers,
        infoMessage: InfoMessage.defaultMessage,
        exception: const AppException(),
      ),
    );
  }

  Future<void> _onMapShowBusStops(MapShowBusStops event, Emitter<MapState> emit) async {
    if (await IOOperations.checkFileExistence('stops.txt') == true) {
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.loading,
        ),
      );
      final busStops = await _getStops.call();
      final calendars = await _getCalendar.call();
      if (!await IOOperations.databaseExists('gtfs')) {
        await _vehicleRepository.parseTrips(calendars);
        await _vehicleRepository.parseStopTimes();
        await _vehicleRepository.parseRoutes();
      }
      final mapMarkers = <MapMarker>[...state.markers];

      for (final busStop in busStops) {
        mapMarkers.add(_createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
      }
      _log.fine('stops length: ${busStops.length} markers length: ${mapMarkers.length}');

      final editedFilters = Map<MapFilters, bool>.from(state.filters);
      editedFilters[MapFilters.busStop] = !editedFilters[MapFilters.busStop]!;
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.success,
          markers: mapMarkers,
          busStopsAdded: true,
          busStops: busStops,
          calendars: calendars,
          filters: editedFilters,
        ),
      );
      add(const _MapMarkerFiltering());
    } else {
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.failure,
          exception: const NoGtfsTextFileIsPresent(),
        ),
      );
    }
  }

  ///If empty - when first time fetching info or when spaces/blank query value is written
  ///If not - filter by query
  Future<void> _onMapSearchByTheQuery(MapSearchByTheQuery event, Emitter<MapState> emit) async {
    emit(state.copyWith(tripStatus: TripStatus.loading));
    if (event.query.trim() != '') {
      final query = event.query.toLowerCase();
      final foundStopInputtedByUser =
          state.currentStops.where((stop) => stop.name.toLowerCase() == query.trim()).toList();
      if (foundStopInputtedByUser.isNotEmpty) {
        _log.fine('$query ${state.pickedStop.name} ${state.currentStops.length}');
        final filteredByUserTrips = await _publicTransportRepository.getTripsBySearchQuery(
            state.pickedStop, foundStopInputtedByUser,);
        emit(
          state.copyWith(filteredByUserTrips: filteredByUserTrips, query: event.query),
        );
        add(const MapPressFilterByDirectionButton(''));
      } else {
        add(const MapPressFilterButton());
      }
    }
  }

  void _onMapShowTodayOrAllTrips(_MapShowTodayOrAllTrips event, Emitter<MapState> emit) {
    if (state.showTripsForToday == ShowTripsForToday.today) {
      add(const _MapLoadTripsForToday());
    } else {
      add(const _MapAddValuesForRepaintingTimeTable());
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
        directionChars: [],
      ),
    );
  }

  void _onMapPressFilterByDirectionButton(
    MapPressFilterByDirectionButton event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(tripStatus: TripStatus.loading));
    final localDirections = state.directionChars;
    for (final map in localDirections) {
      if (map.containsKey(event.direction)) {
        map[event.direction] = !map[event.direction]!;
        break;
      }
    }
    emit(state.copyWith(directionChars: localDirections));
    final keys = state.directionChars
        .where((map) => map.values.first) // keep only maps where the value is true
        .expand((map) => map.keys)
        .toSet()
        .toList();
    if (keys.isEmpty && state.query == '') {
      emit(state.copyWith(filteredByUserTrips: state.currentTrips));
      add(const _MapShowTodayOrAllTrips());
    } else if (keys.isEmpty && state.query != '') {
      emit(state.copyWith(filteredByUserTrips: state.filteredByUserTrips));
      add(const _MapShowTodayOrAllTrips());
    } else if (keys.length == state.directionChars.length) {
      emit(state.copyWith(filteredByUserTrips: []));
      add(const _MapShowTodayOrAllTrips());
    } else {
      add(_MapFilterTripsByDirection(keys));
    }
  }

  Future<void> _onMapFilterTripsByDirection(
    _MapFilterTripsByDirection event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(tripStatus: TripStatus.loading));
    if (event.direction.isEmpty) {
      return;
    }
    final localDirections = state.directionChars;

    // Convert the list of maps to a set of keys where the value is true
    final keys = localDirections
        .where((map) => map.values.first) // keep only maps where the value is true
        .expand((map) => map.keys)
        .toSet();

    final filteredByDirectionTrips = _filterTripsByDirection(state.currentTrips, keys);

    emit(
      state.copyWith(
        filteredByUserTrips: filteredByDirectionTrips,
      ),
    );
    add(const _MapShowTodayOrAllTrips());
  }

  void _onMapMarkerFilterButtonPressed(MapMarkerFilterButtonPressed event, Emitter<MapState> emit) {
    final editedFilters = Map<MapFilters, bool>.from(state.filters);
    editedFilters[event.mapFilter] = !editedFilters[event.mapFilter]!;
    emit(state.copyWith(filters: editedFilters, filteringStatus: true));
    add(const _MapMarkerFiltering());
  }

  void _onMapMarkerFiltering(_MapMarkerFiltering event, Emitter<MapState> emit) {
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
