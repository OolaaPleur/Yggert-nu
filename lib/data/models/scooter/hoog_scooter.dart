// ignore_for_file: avoid_dynamic_calls
import 'package:yggert_nu/data/models/scooter/scooter.dart';

/// Hoog Scooter model.
class HoogScooter extends Scooter {
  /// Hoog Scooter model constructor.
  HoogScooter({
    required String id,
    required int charge,
    required this.number,
    required this.latitude,
    required this.longitude,
    required this.priceInfo,
    required this.pauseInfo,
  }) : super(id, charge, 'Hoog');
  /// Deserialize data into Hoog Scooter object.
  factory HoogScooter.fromJson(Map<String, dynamic> json) {
    return HoogScooter(
      id: json['id'].toString(),
      charge: json['battery_level'] as int,
      number: json['nr'] as String,
      latitude: json['coordinates']['latitude'] as double,
      longitude: json['coordinates']['longitude'] as double,
      priceInfo: '${json['price_info'].toString().substring(0, 5)}€',
      pauseInfo: '${json['pause_info'].toString().substring(0, 5)}€',
    );
  }

  /// Scooter number.
  final String number;

  /// Scooter latitude coordinate.
  final double latitude;

  /// Scooter longitude coordinate.
  final double longitude;

  /// Price info per minute.
  final String priceInfo;

  /// Price info on pause.
  final String pauseInfo;
}
