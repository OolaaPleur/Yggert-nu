part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class MapMarkersPlacingOnMap extends MapEvent {
  const MapMarkersPlacingOnMap();
}

class MapMarkerFilterButtonPressed extends MapEvent {

  const MapMarkerFilterButtonPressed(this.mapFilter);
  final MapFilters mapFilter;

  @override
  List<Object> get props => [mapFilter];
}

class MapMarkerFiltering extends MapEvent {
  const MapMarkerFiltering();
}

class MapShowBusStops extends MapEvent {
  const MapShowBusStops();
}

class MapCloseStopTimesModalBottomSheet extends MapEvent {
  const MapCloseStopTimesModalBottomSheet();
}

class MapChangeTimetableMode extends MapEvent {

  const MapChangeTimetableMode(this.globalShowTripsForToday);
  final GlobalShowTripsForToday globalShowTripsForToday;

  @override
  List<Object> get props => [globalShowTripsForToday];
}

class MapSearchByTheQuery extends MapEvent {

  const MapSearchByTheQuery(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

////////////////////////////////////

class MapShowTripsForCurrentStop extends MapEvent {

  const MapShowTripsForCurrentStop(this.currentStop);
  final Stop currentStop;

  @override
  List<Object> get props => [currentStop];
}

class MapPressFilterButton extends MapEvent {
  const MapPressFilterButton();
}

// BLOC ONLY EVENTS

class MapCheckShowTripsForTodayOrAllWeek extends MapEvent {
  const MapCheckShowTripsForTodayOrAllWeek();
}

class MapCalculateCurrentListsForOneStop extends MapEvent {
  const MapCalculateCurrentListsForOneStop();
}

class MapLoadTripsForToday extends MapEvent {
  const MapLoadTripsForToday();
}

class MapAddValuesForRepaintingTimeTable extends MapEvent {
  const MapAddValuesForRepaintingTimeTable();
}
