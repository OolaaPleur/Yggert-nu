import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:yggert_nu/data/repositories/public_transport_repository.dart';
import 'package:yggert_nu/utils/database/database_operations.dart';
import 'package:yggert_nu/utils/io/io_operations.dart';

import '../../../constants/constants.dart';
import '../../../data/models/estonia_public_transport.dart';
import '../../../data/models/scooter/scooter.dart';
import '../../../data/models/tartu_bike_station.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../domain/usecases/filter_trips_by_direction.dart';
import '../../../domain/usecases/get_calendar.dart';
import '../../../exceptions/exceptions.dart';
import '../../../utils/gtfs_list_operations.dart';
import '../markers/map_marker.dart';

part 'map_bloc_public_transport.dart';
part 'map_bloc_settings.dart';

part 'map_bloc_helpers.dart';

part 'map_event.dart';

part 'map_state.dart';

/// BLoC class, handles [MapEvent]'s and [MapState]
class MapBloc extends Bloc<MapEvent, MapState> {
  /// Constructor for [MapBloc] class.
  MapBloc()
      : _vehicleRepository = GetIt.I<VehicleRepository>(),
        _settingsRepository = GetIt.I<SettingsRepository>(),
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
    on<MapAddRentalCars>(_onMapAddRentalCars);
    on<MapEnlargeIcon>(_onMapEnlargeIcon);

    // Used only inside BLoC
    on<_MapLoadTripsForToday>(_onMapLoadTripsForToday);
    on<_MapAddValuesForRepaintingTimeTable>(_onMapAddValuesForRepaintingTimeTable);
    on<_MapMarkerFiltering>(_onMapMarkerFiltering);
    on<MapPressTheTripButton>(_onMapPressTheTripButton);
    on<_MapFilterTripsByDirection>(_onMapFilterTripsByDirection);
    on<_MapShowTodayOrAllTrips>(_onMapShowTodayOrAllTrips);
    on<MapDeleteSingleBikeStationInfo>(_onMapDeleteSingleBikeStationInfo);
    on<_MapAddMicroMobilityMarkersToList>(_onMapAddMicroMobilityMarkersToList);
    on<MapChangeLowChargeScooterVisibility>(_onMapChangeLowChargeScooterVisibility);
    on<_MapHandleException>(_onMapHandleException);
  }

  final VehicleRepository _vehicleRepository;
  final SettingsRepository _settingsRepository;
  final GetCalendar _getCalendar;
  final FilterTripsByDirection _filterTripsByDirection;
  final PublicTransportRepository _publicTransportRepository;
  final CreateMapMarkerList _createMapMarkerList;

  final _log = Logger('MapBloc');

  Future<void> _onMapAddRentalCars(MapAddRentalCars event, Emitter<MapState> emit) async {
    final mapMarkers = Map.of(state.markers);
    final pickedCity = await _settingsRepository.getStringValue('pickedCity');
    try {
      final chosenCity = City.values
          .firstWhere((e) => e.name == pickedCity, orElse: () => throw const CityIsNotPicked());
      emit(state.copyWith(pickedCity: chosenCity));
      final boltCarsLocations = await _vehicleRepository.getBoltCars(chosenCity.name);
      for (final car in boltCarsLocations) {
        if (mapMarkers[MarkerType.car] == null) {
          // The list does not exist, so create a new list, add the item,
          // and set the new list to the key
          mapMarkers[MarkerType.car] = [_createMapMarkerList.mapMarkerMakeMarkers(car, this)];
        } else {
          // The list exists, so just add the item to the existing list
          mapMarkers[MarkerType.car]!.add(_createMapMarkerList.mapMarkerMakeMarkers(car, this));
        }
      }
    } catch (e) {
      add(_MapHandleException(e));
    }
    emit(
      state.copyWith(
        markers: mapMarkers,
        filteredMarkers: mapMarkers.values.expand((markers) => markers).toList(),
        infoMessage: InfoMessage.defaultMessage,
        exception: const AppException(),
      ),
    );
    add(const _MapMarkerFiltering());
  }

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
    try {
      final singleBikeStation = await _vehicleRepository.getBikeInfo(event.bikeId);
      emit(state.copyWith(singleBikeStation: [singleBikeStation]));
    } catch (e) {
      if (e.runtimeType == CantFetchTuulScootersData) {
        emit(state.copyWith(exception: const CantFetchTartuSmartBikeData()));
      }
      emit(state.copyWith(exception: const NoInternetConnection()));
      _log.severe(e);
    }
  }

  void _onMapEnlargeIcon(MapEnlargeIcon event, Emitter<MapState> emit) {
    emit(state.copyWith(keyFromOpenedMarker: event.keyFromOpenedMarker));
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

    final stateMarkers = Map.of(state.markers)..removeWhere((key, value) => key != MarkerType.stop);
    emit(state.copyWith(markers: stateMarkers));
    try {
      final snackbarNoNeedToDownload = await _vehicleRepository.fetchGtfsData(); // FETCH GTFS DATA
      if (snackbarNoNeedToDownload != InfoMessage.noNeedToDownload) {
        emit(
          state.copyWith(
            publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.initial,
            markers: {},
            busStopsAdded: false,
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
  }

  Future<void> _onMapAddMicroMobilityMarkersToList(
    _MapAddMicroMobilityMarkersToList event,
    Emitter<MapState> emit,
  ) async {
    final mapMarkers = Map.of(state.markers);
    final pickedCity = await _settingsRepository.getStringValue('pickedCity');
    final lowChargeScooterVisibility =
        await _settingsRepository.getBoolValue('low_charge_scooter_visibility');
    try {
      final chosenCity = City.values
          .firstWhere((e) => e.name == pickedCity, orElse: () => throw const CityIsNotPicked());
      emit(state.copyWith(pickedCity: chosenCity));
      final boltScootersLocations = await _vehicleRepository.getBoltScooters(chosenCity.name);
      mapMarkers.addAll(
          _createScooterMarkers(boltScootersLocations, lowChargeScooterVisibility, mapMarkers,),);
    } catch (e) {
      add(_MapHandleException(e));
    }
    try {
      final chosenCity = City.values
          .firstWhere((e) => e.name == pickedCity, orElse: () => throw const CityIsNotPicked());
      emit(state.copyWith(pickedCity: chosenCity));
      if (cityTuulAreas.containsKey(chosenCity.name)) {
        final tuulScootersLocations = await _vehicleRepository.getTuulScooters(chosenCity.name);
        mapMarkers.addAll(
            _createScooterMarkers(tuulScootersLocations, lowChargeScooterVisibility, mapMarkers,),);
      }
    } catch (e) {
      add(_MapHandleException(e));
    }
    if (pickedCity == City.jarvamaa.name || pickedCity == City.raplamaa.name || pickedCity == City.tallinn.name) {
      try {
        final hoogScootersLocations = await _vehicleRepository.getHoogScooters();
        mapMarkers.addAll(
          _createScooterMarkers(hoogScootersLocations, lowChargeScooterVisibility, mapMarkers,),);
      } catch (e) {
        add(_MapHandleException(e));
      }
    }

    if (pickedCity == City.tartu.name) {
      try {
        final bikeLocations = await _vehicleRepository.getTartuBikes();
        for (final bike in bikeLocations) {
          if (mapMarkers[MarkerType.bike] == null) {
            // The list does not exist, so create a new list, add the item,
            // and set the new list to the key
            mapMarkers[MarkerType.bike] = [_createMapMarkerList.mapMarkerMakeMarkers(bike, this)];
          } else {
            // The list exists, so just add the item to the existing list
            mapMarkers[MarkerType.bike]!.add(_createMapMarkerList.mapMarkerMakeMarkers(bike, this));
          }
        }
      } catch (e) {
        add(_MapHandleException(e));
      }
    }
    emit(
      state.copyWith(
        markers: mapMarkers,
        filteredMarkers: mapMarkers.values.expand((markers) => markers).toList(),
        infoMessage: InfoMessage.defaultMessage,
        exception: const AppException(),
      ),
    );
    add(const _MapMarkerFiltering());
  }

  Future<void> _onMapShowBusStops(MapShowBusStops event, Emitter<MapState> emit) async {
    if (await IOOperations.checkFileExistence('stops.txt') == true) {
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.loading,
        ),
      );
      //final busStops = await _getStops.call();
      final calendars = await _getCalendar.call();
      var busStops = <Stop>[];
      if (!await IOOperations.databaseExists('gtfs')) {
        await _vehicleRepository.parseTrips(calendars);
        await _vehicleRepository.parseStopTimes();
        await _vehicleRepository.parseRoutes();
        busStops = await _vehicleRepository.parseStops();
      } else {
        busStops = await _publicTransportRepository.getAllStops();
      }
      final mapMarkers = Map.of(state.markers);

      for (final busStop in busStops) {
        if (mapMarkers[MarkerType.stop] == null) {
          // The list does not exist, so create a new list, add the item,
          // and set the new list to the key
          mapMarkers[MarkerType.stop] = [_createMapMarkerList.mapMarkerMakeMarkers(busStop, this)];
        } else {
          // The list exists, so just add the item to the existing list
          mapMarkers[MarkerType.stop]!
              .add(_createMapMarkerList.mapMarkerMakeMarkers(busStop, this));
        }
      }
      _log.fine('stops length: ${busStops.length} markers length: ${mapMarkers.length}');

      final editedFilters = Map<MapFilters, bool>.from(state.filters);
      editedFilters[MapFilters.busStop] = !editedFilters[MapFilters.busStop]!;
      emit(
        state.copyWith(
          publicTransportStopAdditionStatus: PublicTransportStopAdditionStatus.success,
          markers: mapMarkers,
          busStopsAdded: true,
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

  void _onMapMarkerFilterButtonPressed(MapMarkerFilterButtonPressed event, Emitter<MapState> emit) {
    final editedFilters = Map<MapFilters, bool>.from(state.filters);
    editedFilters[event.mapFilter] = !editedFilters[event.mapFilter]!;
    emit(state.copyWith(filters: editedFilters, filteringStatus: true));
    add(const _MapMarkerFiltering());
  }

  void _onMapMarkerFiltering(_MapMarkerFiltering event, Emitter<MapState> emit) {
    final filteredMarkers = <MapMarker>[];

    if (state.filters[MapFilters.busStop]!) {
      filteredMarkers.addAll(state.markers[MarkerType.stop] ?? []);
    }
    if (state.filters[MapFilters.cycles]!) {
      filteredMarkers.addAll(state.markers[MarkerType.bike] ?? []);
    }
    if (state.filters[MapFilters.scooters]!) {
      filteredMarkers.addAll(state.markers[MarkerType.scooter] ?? []);
    }
    if (state.filters[MapFilters.cars]!) {
      filteredMarkers.addAll(state.markers[MarkerType.car] ?? []);
    }

    emit(
      state.copyWith(
        filteredMarkers: filteredMarkers,
        filteringStatus: false,
        status: MapStateStatus.success,
      ),
    );
  }
}
