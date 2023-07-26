// ignore_for_file: avoid_dynamic_calls
import 'car.dart';
/// Bolt car model.
class BoltCar extends Car {
  /// Bolt car model constructor.
  BoltCar({
    required String id,
    required String pricePerMinute,
    required this.latitude,
    required this.longitude,
    required this.markersGroupId,
  }) : super(id, pricePerMinute, 'Bolt');
  /// Deserialize data into Bolt car object.
  factory BoltCar.fromJson(Map<String, dynamic> json, String pricePerMinute) {
    return BoltCar(
      id: json['id'] as String,
      latitude: double.parse(json['location']['lat'].toString()),
      longitude: double.parse(json['location']['lng'].toString()),
      markersGroupId: json['markers_group_id'] as String,
      pricePerMinute: pricePerMinute,
    );
  }
  /// Car latitude coordinate
  final double latitude;

  /// Car longitude coordinate
  final double longitude;
  /// Marker group id, contains info for example about price per minute.
  final String markersGroupId;
}
