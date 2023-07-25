// ignore_for_file: avoid_dynamic_calls
import 'car.dart';
/// Bolt car model.
class BoltCar extends Car {
  /// Bolt car model constructor.
  BoltCar({
    required String id,
    required this.latitude,
    required this.longitude,
  }) : super(id, 'Bolt');
  /// Deserialize data into Bolt car object.
  factory BoltCar.fromJson(Map<String, dynamic> json) {
    return BoltCar(
      id: json['id'] as String,
      latitude: double.parse(json['location']['lat'].toString()),
      longitude: double.parse(json['location']['lng'].toString()),
    );
  }
  /// Car latitude coordinate
  final double latitude;

  /// Car longitude coordinate
  final double longitude;
}
