part of 'gtfs_bloc.dart';

/// [GtfsEvent] created to extend new [GtfsEvent]'s.
abstract class GtfsEvent extends Equatable {
  /// Constructor for [GtfsEvent].
  const GtfsEvent();
}

/// Event which responsible for emitting states related to text about GTFS
/// data downloading.
class GetGtfsData extends GtfsEvent {
  /// Constructor for [GetGtfsData].
  const GetGtfsData({required this.localizedString});
  /// Context, we need it to access localization string.
  final String  localizedString;

  @override
  List<Object> get props => [localizedString];
}
