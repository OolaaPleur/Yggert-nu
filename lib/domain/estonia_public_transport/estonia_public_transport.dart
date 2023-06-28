/// Public transport Stop object.
class Stop {
  /// Stop constructor.
  const Stop({this.stopId = '', this.name = '', this.latitude = 0, this.longitude = 0});

  /// Stop ID.
  final String stopId;

  /// Stop name.
  final String name;

  /// Stop latitude coordinate.
  final double latitude;

  /// Stop longitude coordinate.
  final double longitude;
}

class Trip {
  Trip(
      {required this.tripId,
      required this.routeId,
      required this.serviceId,
      required this.shapeId,});

  final String tripId;
  final String routeId;
  final String serviceId;
  final String shapeId;
}

class StopTime {
  StopTime({
    required this.tripId,
    required this.stopId,
    required this.arrivalTime,
    required this.departureTime,
    required this.sequence,
  });

  final String tripId;
  final String stopId;
  final String arrivalTime;
  final String departureTime;
  final int sequence;
}

class Calendar {
  Calendar({required this.serviceId, required this.daysOfWeek, required this.startDate, required this.endDate});

  final String serviceId;
  final List<bool> daysOfWeek;
  final DateTime startDate;
  final DateTime endDate;
}
