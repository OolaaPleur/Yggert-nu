part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class MapMarkersPlacingOnMap extends MapEvent {
  const MapMarkersPlacingOnMap();
}

class MapFilteringMarkers extends MapEvent {
  final Map<MapFilters, bool> filters;

  const MapFilteringMarkers(this.filters);

  @override
  List<Object> get props => [filters];
}

class MapShowBusStops extends MapEvent {
  const MapShowBusStops();
}

// Fetching or filtering trips by user input
class MapGetTripsForStopTimesForOneStop extends MapEvent {
  final String query;
  final Stop currentStop;

  const MapGetTripsForStopTimesForOneStop(this.query, this.currentStop);

  @override
  List<Object> get props => [query, currentStop];
}

class MapCloseStopTimesModalBottomSheet extends MapEvent {
  const MapCloseStopTimesModalBottomSheet();
}

class MapShowTripsForToday extends MapEvent {
  const MapShowTripsForToday();
}
