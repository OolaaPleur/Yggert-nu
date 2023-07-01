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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Stop &&
              runtimeType == other.runtimeType &&
              stopId == other.stopId &&
              name == other.name &&
              latitude == other.latitude &&
              longitude == other.longitude;

  @override
  int get hashCode =>
      stopId.hashCode ^
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
}

/// Public transport [Trip] object.
class Trip {
  /// Trip constructor
  Trip(
      {    required this.tripId,
        required this.routeId,
        required this.serviceId,
        required this.tripHeadsign,
        required this.directionId,
        required this.shapeId,
        required this.wheelchairAccessible,});

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
  final String tripHeadsign;
  final String directionId;
  final String wheelchairAccessible;

  // Convert a Trip object into a Map
  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'routeId': routeId,
      'serviceId': serviceId,
      'tripHeadsign': tripHeadsign,
      'directionId': directionId,
      'shapeId': shapeId,
      'wheelchairAccessible': wheelchairAccessible,
    };
  }

  // Create a Trip object from a Map
  static Trip fromMap(Map<String, dynamic> map) {
    return Trip(
      tripId: map['tripId'] as String,
      routeId: map['routeId'] as String,
      serviceId: map['serviceId'] as String,
      tripHeadsign: map['tripHeadsign'] as String,
      directionId: map['directionId'] as String,
      shapeId: map['shapeId'] as String,
      wheelchairAccessible: map['wheelchairAccessible'] as String,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'stopId': stopId,
      'sequence': sequence,
    };
  }
  factory StopTime.fromMap(Map<String, dynamic> map) {
    return StopTime(
      tripId: map['tripId'] as String,
      arrivalTime: map['arrivalTime'] as String,
      departureTime: map['departureTime'] as String,
      stopId: map['stopId'] as String,
      sequence: map['sequence'] as int,
    );
  }
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

class Route {
  String routeId;
  String agencyId;
  String routeShortName;
  String routeLongName;
  int routeType;
  String routeColor;
  String competentAuthority;
  String routeDesc;

  Route({
    required this.routeId,
    required this.agencyId,
    required this.routeShortName,
    required this.routeLongName,
    required this.routeType,
    required this.routeColor,
    required this.competentAuthority,
    required this.routeDesc,
  });

  // Convert a Route object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'route_id': routeId,
      'agency_id': agencyId,
      'route_short_name': routeShortName,
      'route_long_name': routeLongName,
      'route_type': routeType,
      'route_color': routeColor,
      'competent_authority': competentAuthority,
      'route_desc': routeDesc,
    };
  }

  factory Route.fromMap(Map<String, dynamic> map) {
    return Route(
      routeId: map['route_id'] as String,
      agencyId: map['agency_id'] as String,
      routeShortName: map['route_short_name'] as String,
      routeLongName: map['route_long_name'] as String,
      routeType: map['route_type'] as int,
      routeColor: map['route_color'] as String,
      competentAuthority: map['competent_authority'] as String,
      routeDesc: map['route_desc'] as String,
    );
  }
}
