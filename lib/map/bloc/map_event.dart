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
