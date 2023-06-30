/// Public transport [Stop] object.
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

/// Public transport [Trip] object.
class Trip {
  /// Trip constructor
  Trip(
      {required this.tripId,
      required this.routeId,
      required this.serviceId,
      required this.shapeId,});

  /// Trip ID
  final String tripId;
  /// Reference to route record (foreign key)
  final String routeId;
  /// Reference to calendar record, defines dates when service is
  /// available (foreign key)
  final String serviceId;
  /// Reference to shape record. Defines a geospatial form that describes
  /// the movement of a vehicle on a trip.
  final String shapeId;
}

/// Public transport [StopTime] object
class StopTime {
  /// StopTime constructor
  StopTime({
    required this.tripId,
    required this.stopId,
    required this.arrivalTime,
    required this.departureTime,
    required this.sequence,
  });

  /// Reference to trip record (foreign key).
  final String tripId;
  /// Reference to stop record.
  final String stopId;
  /// Arrival time in „HH:mm:00“ format.
  final String arrivalTime;
  /// Departure time in „HH:mm:00“ format.
  final String departureTime;
  /// Stop order for a specific trip.
  final int sequence;
}

/// Public transport [Calendar] object.
class Calendar {
  /// Calendar constructor.
  Calendar({required this.serviceId, required this.daysOfWeek, required this.startDate, required this.endDate});

  /// Primary key for [Calendar] object.
  final String serviceId;
  /// Defines days of week when service is available (true - available,
  /// false - unavailable).
  final List<bool> daysOfWeek;
  /// Defines service date start in „YYYYMMdd“ format
  final DateTime startDate;
  /// Defines service date end in „YYYYMMdd“ format
  final DateTime endDate;
}
