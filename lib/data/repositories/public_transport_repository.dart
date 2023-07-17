import 'package:get_it/get_it.dart';

import '../data_sources/gtfs_data_operations.dart';
import '../models/estonia_public_transport.dart';

/// Repository for operations with GTFS data.
class PublicTransportRepository {
  final _gtfsDataOperations = GetIt.I<GtfsDataOperations>();

  /// Returns all stops.
  Future<List<Stop>> getAllStops() => _gtfsDataOperations.getAllStops();

  /// Returns Stops, with specified in [stopIds] stop id.
  Future<List<Stop>> getCurrentStops(List<String> stopIds) =>
      _gtfsDataOperations.getCurrentStops(stopIds);

  /// Returns stop times for currently picked stop.
  Future<List<StopTime>> getCurrentStopTimes(String stopId) =>
      _gtfsDataOperations.getCurrentStopTimes(stopId);

  /// Returns trips for currently picked stop.
  Future<List<Trip>> getCurrentTrips(List<StopTime> stopTimesList, List<String> tripIds) =>
      _gtfsDataOperations.getCurrentTrips(stopTimesList, tripIds);

  /// Returns unique direction id endings for currently picked stop.
  List<Map<String, bool>> getUniqueDirectionIdEndings(List<Trip> currentTrips) =>
      _gtfsDataOperations.getUniqueDirectionIdEndings(currentTrips);

  /// Returns all stop times for all trips which goes through currently picked stop.
  Future<List<StopTime>> getAllStopTimesForAllTripsWhichGoesThroughCurrentStop(
    List<String> currentTripIds,
  ) =>
      _gtfsDataOperations.getAllStopTimesForAllTripsWhichGoesThroughCurrentStop(currentTripIds);

  /// Returns list of trips in response to search request, made by user for currently picked stop.
  Future<List<Trip>> getTripsBySearchQuery(Stop currentStop, List<Stop> searchedStops) =>
      _gtfsDataOperations.getTripsBySearchQuery(currentStop, searchedStops);
}
