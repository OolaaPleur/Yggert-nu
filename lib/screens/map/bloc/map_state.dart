part of 'map_bloc.dart';

/// Describes map markers placing status.
enum MapStateStatus {
  /// Initial value.
  initial,

  /// Loading, when app starts or when pressed refresh button.
  loading,

  /// When operation of adding markers is finished (could be that no marker
  /// is added though, it just tells that operation is completed).
  success,
}

/// Describes status of stop marker opening and all required info handling.
enum TripStatus {
  /// Initial value, when modal bottom sheet closes, returns to this value.
  initial,

  /// Loading, when values are not ready to be showed to user, needs for
  /// showing loading indicators and showing to user that needed operations
  /// are not yet performed.
  loading,

  /// Success, when all required values are ready to be placed on widget.
  success,
}

/// Describes status of parsing GTFS files and adding them to state.
enum PublicTransportStopAdditionStatus {
  /// Initial value.
  initial,

  /// Loading, when needed operations just begun to be performed.
  loading,

  /// Success, when files parsed and all info added to state successfully.
  success,

  /// Failure, when some error occurs (e.g. file that needs to be parsed not exists).
  failure,
}

/// Describe what filter user picked for his timetable inside modal
/// bottom sheet.
enum ShowTripsForToday {
  /// Default value, shows all trips for current stop.
  all,

  /// Shows trips which only would be today.
  today,
}

/// Describe global filter, picked by user in settings.
enum GlobalShowTripsForToday {
  /// Default value, shows all trips for current stop.
  all,

  /// Shows trips which only would be today.
  today,
}

/// Describe filters for user to press.
enum MapFilters {
  /// Bus stop filter, changes when pressed FAB with buc icon.
  busStop,

  /// Scooter filter, changes when pressed FAB with scooter icon.
  scooters,

  /// Cycle filter, changes when pressed FAB with bike icon.
  cycles
}

/// State of the Map.
final class MapState extends Equatable {
  /// Constructor for the State.
  const MapState({
    this.status = MapStateStatus.initial,
    this.tripStatus = TripStatus.initial,
    this.markers = const <MapMarker>[],
    this.filteredMarkers = const <MapMarker>[],
    this.filters = const {
      MapFilters.cycles: true,
      MapFilters.scooters: true,
      MapFilters.busStop: false
    },
    this.busStopsAdded = false,
    this.currentStopTimes = const <StopTime>[],
    this.busStops = const <Stop>[],
    this.currentTrips = const <Trip>[],
    this.currentTripIds = const <String>[],
    this.allStopTimesForAllTripsWhichGoesThroughCurrentStop = const <StopTime>[],
    this.publicTransportStopAdditionStatus = PublicTransportStopAdditionStatus.initial,
    this.currentStops = const <Stop>[],
    this.presentTripStartStopTimes = const <int, StopTime>{},
    this.presentTripEndStopTimes = const <int, StopTime>{},
    this.presentTripStartStop = const <int, Stop>{},
    this.presentTripEndStop = const <int, Stop>{},
    this.pickedStop = const Stop(),
    this.presentStopStopTimeList = const <int, StopTime>{},
    this.filteredByUserTrips = const <Trip>[],
    this.calendars = const <Calendar>[],
    this.presentTripCalendar = const <int, String>{},
    this.showTripsForToday = ShowTripsForToday.all,
    this.globalShowTripsForToday = GlobalShowTripsForToday.all,
    this.filteringStatus = false,
    this.query = '',
    this.keyFromOpenedMarker = '',
    this.presentStopStopTimeListOnlyFilter = const <int, List<StopTime>>{},
    this.presentStopListOnlyFilter = const <int, List<Stop>>{},
    this.presentRoutes = const <int, Route>{},
    this.pressedButtonOnTrip = const <bool>[],
    this.presentStopsInForwardDirection = const <Stop>[],
    this.directionChars = const <Map<String, bool>>[],
    this.pickedCity = City.tartu,
    this.exception = noException,
    this.singleBikeStation = const <SingleBikeStation>[],
    this.infoMessage = InfoMessage.defaultMessage,
    this.packageName = '',
    this.lowChargeScooterVisibility = true,
  });

  /// Map markers placing status.
  final MapStateStatus status;

  /// List of all markers.
  final List<MapMarker> markers;

  /// List of showed markers.
  final List<MapMarker> filteredMarkers;

  /// List of filters, applied by user.
  final Map<MapFilters, bool> filters;

  // Next two - global lists
  /// List of all parsed bus stops.
  final List<Stop> busStops;

  /// List of all parsed calendars.
  final List<Calendar> calendars;

  /// Picked by user stop.
  final Stop pickedStop;

  // Variables for current picked stop
  /// Stop times for currently picked stop.
  final List<StopTime> currentStopTimes;

  /// Trips for currently picked stop.
  final List<Trip> currentTrips;

  /// Stops for currently picked stop.
  final List<Stop> currentStops;

  /// Trips IDs for currently picked stop.
  final List<String> currentTripIds;

  /// Stop times, for all trips, which goes through current stop.
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;

  // Maps, which are store values for painting the timetable.
  /// Map of starting point stop time for current trip.
  final Map<int, StopTime> presentTripStartStopTimes;

  /// Map of ending point stop time for current trip.
  final Map<int, StopTime> presentTripEndStopTimes;

  /// Map of starting stop for current trip.
  final Map<int, Stop> presentTripStartStop;

  /// Map of ending stop for current trip.
  final Map<int, Stop> presentTripEndStop;

  /// Map of stop time for picked stop.
  final Map<int, StopTime> presentStopStopTimeList;

  /// List of stop times in forward direction for one particular trip.
  final Map<int, List<StopTime>> presentStopStopTimeListOnlyFilter;

  /// List of stops in in forward direction for one particular trip.
  /// We need this list to paint our timetable.
  final Map<int, List<Stop>> presentStopListOnlyFilter;

  /// List of routes for currently picked stop.
  final Map<int, Route> presentRoutes;

  /// Defines a List of bool, is button(for opening forward stop times)
  /// pressed or not.
  final List<bool> pressedButtonOnTrip;

  /// List of stops in in forward direction for one particular trip.
  /// We need this list for our search.
  final List<Stop> presentStopsInForwardDirection;

  /// Calendar for present trip.
  final Map<int, String> presentTripCalendar;

  /// Trips, filtered by user.
  final List<Trip> filteredByUserTrips;

  /// User query for trip searching.
  final String query;

  /// User picked filter for his timetable inside modal bottom sheet.
  final ShowTripsForToday showTripsForToday;

  /// Global filter, picked by user in settings.
  final GlobalShowTripsForToday globalShowTripsForToday;

  /// Bool, needed to check whether we parsed GTFS data or not.
  final bool busStopsAdded;

  /// Status of parsing GTFS files and adding them to state.
  final PublicTransportStopAdditionStatus publicTransportStopAdditionStatus;

  /// Needs to determine, are we filtering or not.
  final bool filteringStatus;

  /// Status of stop marker opening and all required info handling.
  final TripStatus tripStatus;

  /// Key from opened marker.
  final String keyFromOpenedMarker;

  /// Exception, prints in snackbar if necessary.
  final AppException exception;

  /// Message, need to display some states of flow of an app, as [exception]
  /// printed to snackbar if necessary.
  final InfoMessage infoMessage;

  /// List of Maps, with String key (e.g. 'A') and bool value (e.g. true).
  /// Letter is last letter in direction_code, values are false by default.
  /// Defines, show or not trips with respective end direction letter.
  final List<Map<String, bool>> directionChars;

  /// Currently picked city for showing info (e.g. respective scooters
  /// location). Can be changed in settings, by default is Tartu:).
  final City pickedCity;

  /// Stores info about currently picked bike station.
  final List<SingleBikeStation> singleBikeStation;
  /// Stores info about currently picked scooter package name.
  final String packageName;
  /// Filter parameter, if true - shows all scooter (default), if false
  /// shows only scooter with more than 30% charge.
  final bool lowChargeScooterVisibility;

  @override
  List<Object> get props =>
      [
        status,
        markers,
        filteredMarkers,
        filters,
        busStops,
        calendars,
        pickedStop,
        currentStopTimes,
        currentTrips,
        currentStops,
        currentTripIds,
        allStopTimesForAllTripsWhichGoesThroughCurrentStop,
        presentTripStartStopTimes,
        presentTripEndStopTimes,
        presentTripStartStop,
        presentTripEndStop,
        presentStopStopTimeList,
        presentStopStopTimeListOnlyFilter,
        presentStopListOnlyFilter,
        presentRoutes,
        pressedButtonOnTrip,
        presentStopsInForwardDirection,
        presentTripCalendar,
        filteredByUserTrips,
        query,
        showTripsForToday,
        globalShowTripsForToday,
        busStopsAdded,
        publicTransportStopAdditionStatus,
        filteringStatus,
        tripStatus,
        keyFromOpenedMarker,
        exception,
        infoMessage,
        directionChars,
        pickedCity,
        singleBikeStation,
        packageName,
        lowChargeScooterVisibility
      ];

  @override
  String toString() {
    return 'MapState{status: $status, markers: $markers, filteredMarkers: $filteredMarkers, filters: $filters, busStops: $busStops, calendars: $calendars, pickedStop: $pickedStop, currentStopTimes: $currentStopTimes, currentTrips: $currentTrips, currentStops: $currentStops, currentTripIds: $currentTripIds, allStopTimesForAllTripsWhichGoesThroughCurrentStop: $allStopTimesForAllTripsWhichGoesThroughCurrentStop, presentTripStartStopTimes: $presentTripStartStopTimes, presentTripEndStopTimes: $presentTripEndStopTimes, presentTripStartStop: $presentTripStartStop, presentTripEndStop: $presentTripEndStop, presentStopStopTimeList: $presentStopStopTimeList, presentStopStopTimeListOnlyFilter: $presentStopStopTimeListOnlyFilter, presentStopListOnlyFilter: $presentStopListOnlyFilter, presentRoutes: $presentRoutes, pressedButtonOnTrip: $pressedButtonOnTrip, presentStopsInForwardDirection: $presentStopsInForwardDirection, presentTripCalendar: $presentTripCalendar, filteredByUserTrips: $filteredByUserTrips, query: $query, showTripsForToday: $showTripsForToday, globalShowTripsForToday: $globalShowTripsForToday, busStopsAdded: $busStopsAdded, publicTransportStopAdditionStatus: $publicTransportStopAdditionStatus, filteringStatus: $filteringStatus, tripStatus: $tripStatus, keyFromOpenedMarker: $keyFromOpenedMarker, exception: $exception}';
  }

  /// The copyWith method is used to duplicate an existing object, updating
  /// only the required fields, keeping the rest of the fields as they were
  /// in the original object.
  MapState copyWith({
    MapStateStatus? status,
    List<MapMarker>? markers,
    List<MapMarker>? filteredMarkers,
    Map<MapFilters, bool>? filters,
    List<Stop>? busStops,
    List<Calendar>? calendars,
    Stop? pickedStop,
    List<StopTime>? currentStopTimes,
    List<Trip>? currentTrips,
    List<Stop>? currentStops,
    List<String>? currentTripIds,
    List<StopTime>? allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    Map<int, StopTime>? presentTripStartStopTimes,
    Map<int, StopTime>? presentTripEndStopTimes,
    Map<int, Stop>? presentTripStartStop,
    Map<int, Stop>? presentTripEndStop,
    Map<int, StopTime>? presentStopStopTimeList,
    Map<int, List<StopTime>>? presentStopStopTimeListOnlyFilter,
    Map<int, List<Stop>>? presentStopListOnlyFilter,
    Map<int, Route>? presentRoutes,
    List<bool>? pressedButtonOnTrip,
    List<Stop>? presentStopsInForwardDirection,
    Map<int, String>? presentTripCalendar,
    List<Trip>? filteredByUserTrips,
    String? query,
    ShowTripsForToday? showTripsForToday,
    GlobalShowTripsForToday? globalShowTripsForToday,
    bool? busStopsAdded,
    PublicTransportStopAdditionStatus? publicTransportStopAdditionStatus,
    bool? filteringStatus,
    TripStatus? tripStatus,
    String? keyFromOpenedMarker,
    AppException? exception,
    InfoMessage? infoMessage,
    List<Map<String, bool>>? directionChars,
    City? pickedCity,
    List<SingleBikeStation>? singleBikeStation,
    String? packageName,
    bool? lowChargeScooterVisibility,
  }) {
    return MapState(
      status: status ?? this.status,
      markers: markers ?? this.markers,
      filteredMarkers: filteredMarkers ?? this.filteredMarkers,
      filters: filters ?? this.filters,
      busStops: busStops ?? this.busStops,
      calendars: calendars ?? this.calendars,
      pickedStop: pickedStop ?? this.pickedStop,
      currentStopTimes: currentStopTimes ?? this.currentStopTimes,
      currentTrips: currentTrips ?? this.currentTrips,
      currentStops: currentStops ?? this.currentStops,
      currentTripIds: currentTripIds ?? this.currentTripIds,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          allStopTimesForAllTripsWhichGoesThroughCurrentStop ??
              this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      presentTripStartStopTimes: presentTripStartStopTimes ?? this.presentTripStartStopTimes,
      presentTripEndStopTimes: presentTripEndStopTimes ?? this.presentTripEndStopTimes,
      presentTripStartStop: presentTripStartStop ?? this.presentTripStartStop,
      presentTripEndStop: presentTripEndStop ?? this.presentTripEndStop,
      presentStopStopTimeList: presentStopStopTimeList ?? this.presentStopStopTimeList,
      presentStopStopTimeListOnlyFilter:
          presentStopStopTimeListOnlyFilter ?? this.presentStopStopTimeListOnlyFilter,
      presentStopListOnlyFilter: presentStopListOnlyFilter ?? this.presentStopListOnlyFilter,
      presentRoutes: presentRoutes ?? this.presentRoutes,
      pressedButtonOnTrip: pressedButtonOnTrip ?? this.pressedButtonOnTrip,
      presentStopsInForwardDirection:
          presentStopsInForwardDirection ?? this.presentStopsInForwardDirection,
      presentTripCalendar: presentTripCalendar ?? this.presentTripCalendar,
      filteredByUserTrips: filteredByUserTrips ?? this.filteredByUserTrips,
      query: query ?? this.query,
      showTripsForToday: showTripsForToday ?? this.showTripsForToday,
      globalShowTripsForToday: globalShowTripsForToday ?? this.globalShowTripsForToday,
      busStopsAdded: busStopsAdded ?? this.busStopsAdded,
      publicTransportStopAdditionStatus:
          publicTransportStopAdditionStatus ?? this.publicTransportStopAdditionStatus,
      filteringStatus: filteringStatus ?? this.filteringStatus,
      tripStatus: tripStatus ?? this.tripStatus,
      keyFromOpenedMarker: keyFromOpenedMarker ?? this.keyFromOpenedMarker,
      exception: exception ?? this.exception,
      infoMessage: infoMessage ?? this.infoMessage,
      directionChars: directionChars ?? this.directionChars,
      pickedCity: pickedCity ?? this.pickedCity,
      singleBikeStation: singleBikeStation ?? this.singleBikeStation,
      packageName: packageName ?? this.packageName,
      lowChargeScooterVisibility: lowChargeScooterVisibility ?? this.lowChargeScooterVisibility,
    );
  }
}
