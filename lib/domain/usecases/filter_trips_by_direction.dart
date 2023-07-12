

import '../../data/models/estonia_public_transport.dart';

/// Use case, needed to filter trips by its direction.
class FilterTripsByDirection {
  /// Call function for [FilterTripsByDirection] function.
  List<Trip> call(List<Trip> trips, Set<String> directions) {
    return trips.where((trip) {
      if (trip.directionId.isNotEmpty) {
        final lastLetter = trip.directionId[trip.directionId.length - 1];
        return directions.contains(lastLetter);
      }
      return false;
    }).toList();
  }
}
