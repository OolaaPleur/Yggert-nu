part of 'map_bloc.dart';

/// Helper functions for MapBloc (functions, that not events).
extension MapBlocHelpers on MapBloc {
  void _onMapHandleException(_MapHandleException event, Emitter<MapState> emit) {
    if (event.exception is CantFetchBoltScootersData ||
        event.exception is CantFetchTuulScootersData ||
        event.exception is CantFetchHoogScootersData ||
        event.exception is CantFetchTartuSmartBikeData ||
        event.exception is CantFetchBoltCarsData) {
      emit(state.copyWith(exception: event.exception as AppException));
    } else if (event.exception is NoInternetConnection) {
      emit(state.copyWith(exception: const NoInternetConnection()));
    } else if (event.exception is CityIsNotPicked) {
      emit(state.copyWith(exception: const CityIsNotPicked()));
    } else if (event.exception is DeviceIsNotSupported) {
      emit(state.copyWith(exception: const DeviceIsNotSupported()));
    }
    _log.severe(event.exception);
  }

  Map<MarkerType, List<MapMarker>> _createScooterMarkers(
      List<Scooter> vehicles,
      bool lowChargeScooterVisibility,
      Map<MarkerType, List<MapMarker>> mapMarkers,
      ) {
    for (final scooters in vehicles) {
      if (scooters.charge < 30 && !lowChargeScooterVisibility) {
        continue;
      }
      mapMarkers.putIfAbsent(MarkerType.scooter, () => []);
      mapMarkers[MarkerType.scooter]!
          .add(_createMapMarkerList.mapMarkerMakeMarkers(scooters, this));
    }
    return mapMarkers;
  }
}
