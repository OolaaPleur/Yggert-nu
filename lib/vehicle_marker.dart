import 'package:flutter_map/flutter_map.dart';
enum MarkerType { person, car, scooter, bike }
class VehicleMarker extends Marker {
  final MarkerType markerType;

  VehicleMarker({
    required this.markerType,
    required width,
    required height,
    required point,
    required builder,
    required key,
  }) : super(width: width, height: height, point: point, builder: builder, key: key);
}