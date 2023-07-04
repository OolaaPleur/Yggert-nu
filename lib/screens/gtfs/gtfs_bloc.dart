import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/vehicle_repository.dart';

part 'gtfs_event.dart';
part 'gtfs_state.dart';

/// BLoC class, manages text in settings, when/if GTFS file was
/// downloaded.
class GtfsBloc extends Bloc<GtfsEvent, GtfsState> {
  /// Constructor for [GtfsBloc].
  GtfsBloc({required VehicleRepository vehicleRepository}) : _vehicleRepository = vehicleRepository, super(GtfsInitial()) {
    on<GetGtfsData>(_onMapEventToState);
  }
  ///
  final VehicleRepository _vehicleRepository;

  Future<void> _onMapEventToState(GtfsEvent event, Emitter<GtfsState>emit) async {
    if (event is GetGtfsData) {
      final dateOfGtfsDataDownload = await _vehicleRepository.getValue('gtfs_download_date');

      if (dateOfGtfsDataDownload == 'no data') {
        emit(GtfsNoData());
      } else {
        final result = '${event.localizedString} ${dateOfGtfsDataDownload.substring(0, dateOfGtfsDataDownload.length - 4)}';
        emit(GtfsDataLoaded(result));
      }
    }
  }
}
