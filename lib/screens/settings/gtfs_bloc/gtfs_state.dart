part of 'gtfs_bloc.dart';

/// State of the GTFS text field.
abstract class GtfsState extends Equatable {
  /// Constructor for [GtfsState].
  const GtfsState();

  @override
  List<Object> get props => [];
}

/// Initial state.
class GtfsInitial extends GtfsState {}
/// State, emits when no data related to downloading date is found.
class GtfsNoData extends GtfsState {}
/// State, emits when downloading date is found.
class GtfsDataLoaded extends GtfsState {
  /// Constructor for [GtfsDataLoaded].
  const GtfsDataLoaded(this.result);
  /// Downloading date in string format.
  final String result;

  @override
  List<Object> get props => [result];
}
