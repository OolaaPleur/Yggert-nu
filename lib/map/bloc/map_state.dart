part of 'map_bloc.dart';

enum MapStateStatus { initial, loading, success, failure, }

enum MapFilters { cars, scooters, cycles }

class MapState extends Equatable {
  const MapState({
    this.status = MapStateStatus.loading,
    this.markers = const <MapMarker>[],
    this.filteredMarkers = const <MapMarker>[],
    this.filters = const {
      MapFilters.cars: true,
      MapFilters.cycles: true,
      MapFilters.scooters: true
    },
  });

  final MapStateStatus status;
  final List<MapMarker> markers;
  final List<MapMarker> filteredMarkers;
  final Map<MapFilters, bool> filters;

  @override
  List<Object?> get props => [
        status,
        markers,
        filters,
        filteredMarkers
      ];

  MapState copyWith({
    MapStateStatus? status,
    List<MapMarker>? markers,
    List<MapMarker>? filteredMarkers,
    Map<MapFilters, bool>? filters,
  }) {
    return MapState(
      status: status ?? this.status,
      markers: markers ?? this.markers,
      filteredMarkers: filteredMarkers ?? this.filteredMarkers,
      filters: filters ?? this.filters,
    );
  }
}
