import '../../utils/database/database_operations.dart';
import '../models/estonia_public_transport.dart';

/// Class, which defines operations with GTFS data.
class GtfsDataOperations {
  /// Returns stop times for currently picked stop.
  Future<List<StopTime>> getCurrentStopTimes(String stopId) async {
    final stopTimesDb = await DatabaseOperations.openAppDatabase('gtfs');
    final currentStopTimesMaps =
        await stopTimesDb.query('stop_times', where: 'stop_id = ?', whereArgs: [stopId]);
    // Convert from map to list and sort by arrival time.
    final currentStopTimes = currentStopTimesMaps.map(StopTime.fromMap).toList()
      ..sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    await DatabaseOperations.closeDatabase(stopTimesDb);
    return currentStopTimes;
  }

  /// Returns all stops.
  Future<List<Stop>> getAllStops() async {
    final stopsDb = await DatabaseOperations.openAppDatabase('gtfs');
    final List<Map<String, dynamic>> maps = await stopsDb.query('stops');

    return List.generate(maps.length, (i) {
      return Stop.fromMap(maps[i]);
    });
  }

  /// Returns Stops, with specified in [stopIds] stop id.
  Future<List<Stop>> getCurrentStops(List<String> stopIds) async {
    final stopsDb = await DatabaseOperations.openAppDatabase('gtfs');
    final stops = <Stop>[];

    for (final stopId in stopIds) {
      final List<Map<String, dynamic>> maps = await stopsDb.query(
        'stops',
        where: 'stop_id = ?',
        whereArgs: [stopId],
      );

      if (maps.isNotEmpty) {
        stops.add(Stop.fromMap(maps.first));
      }
    }

    return stops;
  }

  /// Returns trips for currently picked stop.
  Future<List<Trip>> getCurrentTrips(List<StopTime> stopTimesList, List<String> tripIds) async {
    final tripsDb = await DatabaseOperations.openAppDatabase('gtfs');
    final placeholders = List<String>.filled(tripIds.length, '?').join(', ');
    final currentTripsMaps = await tripsDb.query(
      'trips',
      where: 'trip_id IN ($placeholders)',
      whereArgs: tripIds,
    );
    await DatabaseOperations.closeDatabase(tripsDb);
    // Convert from map to list and sort so, that trips will be in same order
    // as corresponding object in stop time list.
    return currentTripsMaps.map(Trip.fromMap).toList()
      ..sort((a, b) {
        final indexA = stopTimesList.indexWhere((stopTime) => stopTime.tripId == a.tripId);
        final indexB = stopTimesList.indexWhere((stopTime) => stopTime.tripId == b.tripId);
        return indexA.compareTo(indexB);
      });
  }

  /// Returns unique direction id endings for currently picked stop.
  List<Map<String, bool>> getUniqueDirectionIdEndings(List<Trip> currentTrips) {
    final directionIdEndings = <String>{};
    for (final trip in currentTrips) {
      if (trip.directionId.isNotEmpty) {
        directionIdEndings.add(trip.directionId[trip.directionId.length - 1]);
      }
    }
    return directionIdEndings.map((s) {
      return {s: false};
    }).toList();
  }

  /// Returns all stop times for all trips which goes through currently picked stop.
  Future<List<StopTime>> getAllStopTimesForAllTripsWhichGoesThroughCurrentStop (List<String> currentTripIds) async {
    final stopTimesDb = await DatabaseOperations.openAppDatabase('gtfs');
    final placeholdersD = List<String>.filled(currentTripIds.length, '?').join(', ');
    final allStopTimesForAllTripsWhichGoesThroughCurrentStopMaps = await stopTimesDb.query(
      'stop_times',
      where: 'trip_id IN ($placeholdersD)',
      whereArgs: currentTripIds,
    );
    return allStopTimesForAllTripsWhichGoesThroughCurrentStopMaps.map(StopTime.fromMap).toList();
  }

  /// Returns list of trips in response to search request, made by user for currently picked stop.
  Future<List<Trip>> getTripsBySearchQuery(Stop currentStop, List<Stop> searchedStops) async {
    final gtfsDb = await DatabaseOperations.openAppDatabase('gtfs');
    final rows = await gtfsDb.rawQuery(
      '''
          SELECT *
          FROM trips
          WHERE trip_id IN (
              SELECT DISTINCT st1.trip_id
              FROM stop_times st1
              JOIN stop_times st2 ON st1.trip_id = st2.trip_id
              WHERE st1.stop_id = ? 
              AND st2.stop_id IN (?, ?)
              AND st1.sequence < st2.sequence
          )
          ''',
      [
        currentStop.stopId,
        searchedStops.first.stopId,
        searchedStops.last.stopId,
      ],
    );
    final currentStopTimes =
        await getCurrentStopTimes(currentStop.stopId); //TODO POSSIBLY UNEFFECTIVE CODE.
    final tripList = rows.map(Trip.fromMap).toList()
      ..sort((a, b) {
        final indexA = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == a.tripId);
        final indexB = currentStopTimes.indexWhere((stopTime) => stopTime.tripId == b.tripId);
        return indexA.compareTo(indexB);
      });
    return tripList;
  }
}
