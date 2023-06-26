class Stop {
  final String stopId;
  final String name;
  final double latitude;
  final double longitude;

  const Stop({this.stopId = '', this.name = '', this.latitude = 0, this.longitude = 0});
}

class Trip {
  final String tripId;
  final String routeId;
  final String serviceId;

  Trip({required this.tripId, required this.routeId, required this.serviceId});
}

class StopTime {
  final String tripId;
  final String stopId;
  final String arrivalTime;
  final String departureTime;
  final int sequence;

  StopTime({
    required this.tripId,
    required this.stopId,
    required this.arrivalTime,
    required this.departureTime,
    required this.sequence,
  });
}

class Calendar {
  final String serviceId;
  final List<bool> daysOfWeek;

  Calendar({required this.serviceId, required this.daysOfWeek});
}