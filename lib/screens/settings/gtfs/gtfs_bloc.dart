import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/settings_repository.dart';

part 'gtfs_event.dart';

part 'gtfs_state.dart';

/// BLoC class, manages text in settings, when/if GTFS file was
/// downloaded.
class GtfsBloc extends Bloc<GtfsEvent, GtfsState> {
  /// Constructor for [GtfsBloc].
  GtfsBloc()
      : _settingsRepository = GetIt.I<SettingsRepository>(),
        super(GtfsInitial()) {
    on<GetGtfsData>(_onGetGtfsData);
  }

  ///
  final SettingsRepository _settingsRepository;

  Future<void> _onGetGtfsData(GtfsEvent event, Emitter<GtfsState> emit) async {
    if (event is GetGtfsData) {
      final dateOfGtfsDataDownload =
          await _settingsRepository.getStringValue('gtfs_download_date');

      if (dateOfGtfsDataDownload == 'no data') {
        emit(GtfsNoData());
      } else {
        final result =
            '${event.localizedString} ${dateOfGtfsDataDownload.substring(0, dateOfGtfsDataDownload.length - 4)}';
        emit(GtfsDataLoaded(result));
      }
    }
  }
}
