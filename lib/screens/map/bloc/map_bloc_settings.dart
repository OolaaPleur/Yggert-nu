part of 'map_bloc.dart';

/// Events, related to changing global settings inside MapBloc.
extension MapBlocSettings on MapBloc {
  void _onMapChangeTimetableMode(MapChangeTimetableMode event, Emitter<MapState> emit) {
    _settingsRepository.setStringValue('userTripsFilterValue', event.globalShowTripsForToday.name);
    emit(state.copyWith(globalShowTripsForToday: event.globalShowTripsForToday));
  }

  void _onMapChangeLowChargeScooterVisibility(
      MapChangeLowChargeScooterVisibility event,
      Emitter<MapState> emit,
      ) {
    _settingsRepository.setBoolValue('low_charge_scooter_visibility', value: event.visibility);
    emit(state.copyWith(lowChargeScooterVisibility: event.visibility));
  }

  void _onMapChangeCity(MapChangeCity event, Emitter<MapState> emit) {
    _settingsRepository.setStringValue('pickedCity', event.pickedCity.name);
    emit(state.copyWith(pickedCity: event.pickedCity));
  }
}
