import 'package:flutter_map/flutter_map.dart';
enum VehicleType { car, scooter, bike }
class VehicleMarker extends Marker {
  final VehicleType vehicleType;

  VehicleMarker({
    required this.vehicleType,
    required width,
    required height,
    required point,
    required builder,
    required key,
  }) : super(width: width, height: height, point: point, builder: builder, key: key);
}