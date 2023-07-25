import 'car.dart';

class BoltCar extends Car {
  BoltCar({
    required String id,
    required this.latitude,
    required this.longitude,
  }) : super(id, 'Bolt');
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
