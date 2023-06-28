part of 'map_bloc.dart';

enum MapStateStatus {
  initial,
  loading,
  success,
  failure,
}

enum TripStatus {
  initial,
  loading,
  success,
  failure,
}

enum SearchResultsLoading {
  initial,
  loading,
  success,
  failure,
}

enum BusStopAdditionStatus {
  initial,
  loading,
  success,
  failure,
}

enum ShowTripsForToday {
  all,
  today,
}

enum GlobalShowTripsForToday {
  all,
  today,
}

enum MapFilters { busStop, scooters, cycles }

/// State of the Map.
final class MapState extends Equatable {
  /// Constructor for the State.
  const MapState({this.status = MapStateStatus.initial,
    this.tripStatus = TripStatus.initial,
    this.markers = const <MapMarker>[],
    this.filteredMarkers = const <MapMarker>[],
    this.filters = const {MapFilters.cycles: true, MapFilters.scooters: true, MapFilters.busStop: false},
    this.busStopsAdded = false,
    this.stopTimes = const <StopTime>[],
    this.currentStopTimes = const <StopTime>[],
    this.busStops = const <Stop>[],
    this.trips = const <Trip>[],
    this.currentTrips = const <Trip>[],
    this.currentTripIds = const <String>[],
    this.allStopTimesForAllTripsWhichGoesThroughCurrentStop = const <StopTime>[],
    this.busStopAdditionStatus = BusStopAdditionStatus.initial,
    this.currentStops = const <Stop>[],
    this.presentTripStartStopTimes = const <int, StopTime>{},
    this.presentTripEndStopTimes = const <int, StopTime>{},
    this.presentTripStartStop = const <int, Stop>{},
    this.presentTripEndStop = const <int, Stop>{},
    this.pickedStop = const Stop(),
    this.presentStopStopTimeList = const <int, StopTime>{},
    this.filteredByUserTrips = const <Trip>[],
    this.searchResultsLoading = SearchResultsLoading.initial,
    this.calendars = const <Calendar>[],
    this.presentTripCalendar = const <int, String>{},
    this.showTripsForToday = ShowTripsForToday.all,
    this.globalShowTripsForToday = GlobalShowTripsForToday.all,
    this.filteringStatus = false,
    this.currentsLoaded = false,
  this.query = '',});

  final MapStateStatus status;
  final List<MapMarker> markers;
  final List<MapMarker> filteredMarkers;
  final Map<MapFilters, bool> filters;

  // Next four - global lists
  final List<StopTime> stopTimes;
  final List<Stop> busStops;
  final List<Trip> trips;
  final List<Calendar> calendars;

  // Picked Stop
  final Stop pickedStop;

  // Variables for current picked stop
  final List<StopTime> currentStopTimes;
  final List<Trip> currentTrips;
  final List<Stop> currentStops;
  final List<String> currentTripIds;
  final List<StopTime> allStopTimesForAllTripsWhichGoesThroughCurrentStop;
  final bool currentsLoaded;

  // Start/End StopTime and Stop
  final Map<int, StopTime> presentTripStartStopTimes;
  final Map<int, StopTime> presentTripEndStopTimes;
  final Map<int, Stop> presentTripStartStop;
  final Map<int, Stop> presentTripEndStop;
  final Map<int, StopTime> presentStopStopTimeList;

  // Calender for present trip
  final Map<int, String> presentTripCalendar;

  // Trips, filtered by user searching
  final List<Trip> filteredByUserTrips;
  final SearchResultsLoading searchResultsLoading;
  final String query;

  // Show local trips for today
  final ShowTripsForToday showTripsForToday;

  // Global variable for showing trips for today
  final GlobalShowTripsForToday globalShowTripsForToday;

  final bool busStopsAdded;
  final BusStopAdditionStatus busStopAdditionStatus;
  final bool filteringStatus;
  final TripStatus tripStatus;

  @override
  List<Object> get props =>
      [
        status,
        markers,
        filteredMarkers,
        filters,
        stopTimes,
        busStops,
        trips,
        calendars,
        pickedStop,
        currentStopTimes,
        currentTrips,
        currentStops,
        currentTripIds,
        allStopTimesForAllTripsWhichGoesThroughCurrentStop,
        currentsLoaded,
        presentTripStartStopTimes,
        presentTripEndStopTimes,
        presentTripStartStop,
        presentTripEndStop,
        presentStopStopTimeList,
        presentTripCalendar,
        filteredByUserTrips,
        searchResultsLoading,
        showTripsForToday,
        globalShowTripsForToday,
        busStopsAdded,
        busStopAdditionStatus,
        filteringStatus,
        tripStatus,
        query
      ];

  MapState copyWith({
    MapStateStatus? status,
    List<MapMarker>? markers,
    List<MapMarker>? filteredMarkers,
    Map<MapFilters, bool>? filters,
    List<StopTime>? stopTimes,
    List<Stop>? busStops,
    List<Trip>? trips,
    List<Calendar>? calendars,
    Stop? pickedStop,
    List<StopTime>? currentStopTimes,
    List<Trip>? currentTrips,
    List<Stop>? currentStops,
    List<String>? currentTripIds,
    List<StopTime>? allStopTimesForAllTripsWhichGoesThroughCurrentStop,
    bool? currentsLoaded,
    Map<int, StopTime>? presentTripStartStopTimes,
    Map<int, StopTime>? presentTripEndStopTimes,
    Map<int, Stop>? presentTripStartStop,
    Map<int, Stop>? presentTripEndStop,
    Map<int, StopTime>? presentStopStopTimeList,
    Map<int, String>? presentTripCalendar,
    List<Trip>? filteredByUserTrips,
    SearchResultsLoading? searchResultsLoading,
    String? query,
    ShowTripsForToday? showTripsForToday,
    GlobalShowTripsForToday? globalShowTripsForToday,
    bool? busStopsAdded,
    BusStopAdditionStatus? busStopAdditionStatus,
    bool? filteringStatus,
    TripStatus? tripStatus,
  }) {
    return MapState(
      status: status ?? this.status,
      markers: markers ?? this.markers,
      filteredMarkers: filteredMarkers ?? this.filteredMarkers,
      filters: filters ?? this.filters,
      stopTimes: stopTimes ?? this.stopTimes,
      busStops: busStops ?? this.busStops,
      trips: trips ?? this.trips,
      calendars: calendars ?? this.calendars,
      pickedStop: pickedStop ?? this.pickedStop,
      currentStopTimes: currentStopTimes ?? this.currentStopTimes,
      currentTrips: currentTrips ?? this.currentTrips,
      currentStops: currentStops ?? this.currentStops,
      currentTripIds: currentTripIds ?? this.currentTripIds,
      allStopTimesForAllTripsWhichGoesThroughCurrentStop:
          allStopTimesForAllTripsWhichGoesThroughCurrentStop ??
              this.allStopTimesForAllTripsWhichGoesThroughCurrentStop,
      currentsLoaded: currentsLoaded ?? this.currentsLoaded,
      presentTripStartStopTimes: presentTripStartStopTimes ?? this.presentTripStartStopTimes,
      presentTripEndStopTimes: presentTripEndStopTimes ?? this.presentTripEndStopTimes,
      presentTripStartStop: presentTripStartStop ?? this.presentTripStartStop,
      presentTripEndStop: presentTripEndStop ?? this.presentTripEndStop,
      presentStopStopTimeList: presentStopStopTimeList ?? this.presentStopStopTimeList,
      presentTripCalendar: presentTripCalendar ?? this.presentTripCalendar,
      filteredByUserTrips: filteredByUserTrips ?? this.filteredByUserTrips,
      searchResultsLoading: searchResultsLoading ?? this.searchResultsLoading,
      query: query ?? this.query,
      showTripsForToday: showTripsForToday ?? this.showTripsForToday,
      globalShowTripsForToday: globalShowTripsForToday ?? this.globalShowTripsForToday,
      busStopsAdded: busStopsAdded ?? this.busStopsAdded,
      busStopAdditionStatus: busStopAdditionStatus ?? this.busStopAdditionStatus,
      filteringStatus: filteringStatus ?? this.filteringStatus,
      tripStatus: tripStatus ?? this.tripStatus,
    );
  }
}
