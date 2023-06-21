import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/widgets/map_marker.dart';

import '../../domain/vehicle_repository.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required VehicleRepository vehicleRepository})
      : super(const MapState()) {
    on<MapMarkersPlacingOnMap>(_onMapMarkersPlacingOnMap);
    on<MapFilteringMarkers>(_onMapFilteringMarkers);
  }

  Future<void> _onMapMarkersPlacingOnMap(event, emit) async {
    emit(state.copyWith(markers: []));

    VehicleRepository vehicleRepository = VehicleRepository();
    final scootersLocations = await vehicleRepository.getBoltScooters();
    final bikeLocations = await vehicleRepository.getTartuBikes();
    List<MapMarker> mapMarkers = [];
    CreateMapMarkerList createMapMarkerList = CreateMapMarkerList();

    for (final bike in bikeLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(bike));
    }
    for (final scooter in scootersLocations) {
      mapMarkers.add(createMapMarkerList.mapMarkerMakeMarkers(scooter));
    }
    debugPrint(state.markers.length.toString());
    emit(state.copyWith(
        status: MapStateStatus.success,
        markers: mapMarkers,
        filteredMarkers: mapMarkers,
        filters: {
          MapFilters.cars: true,
          MapFilters.cycles: true,
          MapFilters.scooters: true
        }));
  }

  Future<void> _onMapFilteringMarkers(event, emit) async {
    emit(state.copyWith(filters: event.filters));
    List<MapMarker> filteredMarkers = [];
    MapMarker mapMarker = MapMarker(markerType: MarkerType.none);
    for (mapMarker in state.markers) {
      if ((state.filters[MapFilters.cars] as bool &&
              mapMarker.markerType == MarkerType.car) ||
          (state.filters[MapFilters.cycles] as bool &&
              mapMarker.markerType == MarkerType.bike) ||
          (state.filters[MapFilters.scooters] as bool &&
              mapMarker.markerType == MarkerType.scooter) ||
          (mapMarker.markerType == MarkerType.person)) {
        if (mapMarker.markerType == MarkerType.person) {
        }
        filteredMarkers.add(mapMarker);
      }
    }
    emit(state.copyWith(filteredMarkers: filteredMarkers));
  }
}
