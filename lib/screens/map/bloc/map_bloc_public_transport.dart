part of 'map_bloc.dart';

/// All events, related to public transport info managing inside MapBloc.
extension MapBlocPublicTransport on MapBloc {
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

    final currentStops = await _publicTransportRepository.getCurrentStops(stopIds.toList());

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
          state.pickedStop,
          foundStopInputtedByUser,
        );
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
}
