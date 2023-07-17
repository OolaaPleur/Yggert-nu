import 'package:equatable/equatable.dart';

/// Public transport [Stop] object.
class Stop extends Equatable {
  /// Stop constructor.
  const Stop({this.stopId = '', this.name = '', this.latitude = 0, this.longitude = 0});

  /// Create a Stop object from a Map.
  factory Stop.fromMap(Map<String, dynamic> map) {
    return Stop(
      stopId: map['stop_id'] as String,
      name: map['stop_name'] as String,
      latitude: map['stop_lat'] as double,
      longitude: map['stop_lon'] as double,
    );
  }

  /// Stop ID.
  final String stopId;

  /// Stop name.
  final String name;

  /// Stop latitude coordinate.
  final double latitude;

  /// Stop longitude coordinate.
  final double longitude;

  @override
  List<Object> get props => [stopId, name, latitude, longitude];

  /// Converts Stop object to map.
  Map<String, dynamic> toMap() {
    return {
      'stop_id': stopId,
      'stop_name': name,
      'stop_lat': latitude,
      'stop_lon': longitude,
    };
  }
}

/// Public transport [Trip] object.
class Trip {
  /// Trip constructor
  Trip({
    required this.tripId,
    required this.routeId,
    required this.serviceId,
    required this.tripHeadsign,
    required this.directionId,
    required this.shapeId,
    required this.wheelchairAccessible,
  });

  /// Create a Trip object from a Map.
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      tripId: map['trip_id'] as String,
      routeId: map['route_id'] as String,
      serviceId: map['service_id'] as String,
      tripHeadsign: map['trip_headsign'] as String,
      directionId: map['direction_id'] as String,
      shapeId: map['shape_id'] as String,
      wheelchairAccessible: map['wheelchair_accessible'] as String,
    );
  }

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

  /// Destination point of trip.
  final String tripHeadsign;

  /// Movement direction of transport.
  final String directionId;

  /// Indicates whether wheelchair access is available on this trip.
  final String wheelchairAccessible;

  /// Convert a Trip object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'trip_id': tripId,
      'route_id': routeId,
      'service_id': serviceId,
      'trip_headsign': tripHeadsign,
      'direction_id': directionId,
      'shape_id': shapeId,
      'wheelchair_accessible': wheelchairAccessible,
    };
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

  /// Create a StopTime object from a Map.
  factory StopTime.fromMap(Map<String, dynamic> map) {
    return StopTime(
      tripId: map['trip_id'] as String,
      arrivalTime: map['arrival_time'] as String,
      departureTime: map['departure_time'] as String,
      stopId: map['stop_id'] as String,
      sequence: map['sequence'] as int,
    );
  }

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

  /// Create a Map from StopTime object.
  Map<String, dynamic> toMap() {
    return {
      'trip_id': tripId,
      'arrival_time': arrivalTime,
      'departure_time': departureTime,
      'stop_id': stopId,
      'sequence': sequence,
    };
  }
}

/// Public transport [Calendar] object.
class Calendar {
  /// Calendar constructor.
  Calendar({
    required this.serviceId,
    required this.daysOfWeek,
    required this.startDate,
    required this.endDate,
  });

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

/// Public transport [Route] object.
class Route {
  /// Route constructor.
  Route({
    required this.routeId,
    required this.agencyId,
    required this.routeShortName,
    required this.routeLongName,
    required this.routeType,
    required this.routeColor,
    required this.competentAuthority,
  });

  /// Create a Route object from a Map.
  factory Route.fromMap(Map<String, dynamic> map) {
    return Route(
      routeId: map['route_id'] as String,
      agencyId: map['agency_id'] as String,
      routeShortName: map['route_short_name'] as String,
      routeLongName: map['route_long_name'] as String,
      routeType: map['route_type'] as int,
      routeColor: map['route_color'] as String,
      competentAuthority: map['competent_authority'] as String,
    );
  }

  /// ID unique for route.
  String routeId;

  /// Agency ID, defines service provider.
  String agencyId;

  /// Route short name in numerical form.
  String routeShortName;

  /// Route full name, consist of start stop, end stop and key stops along the way.
  String routeLongName;

  /// Type of public transport, 0 - tram, 2 - train, 3 - bus, 4 - ferry,
  /// 800 - trolleybus.
  int routeType;

  /// Route color in hex form.
  String routeColor;

  /// Competent authority that has signed a public service contract for the line
  /// service contract or issued a route permit.
  String competentAuthority;

  /// Convert a Route object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'route_id': routeId,
      'agency_id': agencyId,
      'route_short_name': routeShortName,
      'route_long_name': routeLongName,
      'route_type': routeType,
      'route_color': routeColor,
      'competent_authority': competentAuthority,
    };
  }
}
