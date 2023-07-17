// ignore_for_file: avoid_dynamic_calls
import 'scooter/scooter.dart';

/// Tuul Scooter model.
class TuulScooter extends Scooter {
  /// Tuul Scooter model constructor.
  TuulScooter({
    required String id,
    required int charge,
    required this.estimatedRange,
    required this.shortCode,
    required this.lat,
    required this.lon,
    required this.isInParkingZone,
  }) : super(id, charge, 'Tuul');

  /// Deserialize data into Tuul Scooter object.
  factory TuulScooter.fromJson(Map<String, dynamic> json) {
    return TuulScooter(
      id: json['id'] as String,
      estimatedRange: json['estimatedRange'] as int,
      shortCode: json['shortCode'] as String,
      charge: json['soc'] as int,
      lat: json['location']['lat'] as double,
      lon: json['location']['lon'] as double,
      isInParkingZone: json['isInParkingZone'] as bool,
    );
  }
  /// Scooters estimated range, probably in kilometers.
  final int estimatedRange;
  /// Scooters short code (opposing to id, which is long).
  final String shortCode;
  /// Scooter latitude coordinate
  final double lat;
  /// Scooter longitude coordinate
  final double lon;
  /// Shows is scooter located in parking zone or not.
  final bool isInParkingZone;
}
