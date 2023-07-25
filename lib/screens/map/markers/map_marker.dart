import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:mobility_app/data/models/scooter/hoog_scooter.dart';

import '../../../data/models/car/bolt_car.dart';
import '../../../data/models/estonia_public_transport.dart';
import '../../../data/models/scooter/bolt_scooter.dart';
import '../../../data/models/scooter/tuul_scooter.dart';
import '../../../data/models/tartu_bike_station.dart';
import '../bloc/map_bloc.dart';
import 'marker_types/bike_marker.dart';
import 'marker_types/car_marker.dart';
import 'marker_types/scooter_marker.dart';
import 'marker_types/stop_marker.dart';

/// Type of the marker.
enum MarkerType {
  /// Public transport stop.
  stop,

  /// Scooter.
  scooter,

  /// Bike.
  bike,

  /// Car
  car,

  /// Default marker type.
  none
}

/// Map marker class.
class MapMarker extends Marker {
  /// Map marker constructor.
  MapMarker({
    required this.markerType,
    double? width,
    double? height,
    LatLng? point,
    WidgetBuilder? builder,
    Key? key,
  }) : super(
          width: width ?? 0,
          height: height ?? 0,
          point: point ?? LatLng(0, 0),
          builder: builder ?? (_) => Container(),
          key: key ?? const Key('no_key_from_server'),
        );

  /// Type of the marker.
  final MarkerType markerType;
}

/// Class for markers creation.
class CreateMapMarkerList {
  final _log = Logger('CreateMapMarkerList');

  /// Create map marker, so after it could be returned.
  MapMarker mapMarker = MapMarker(markerType: MarkerType.none);

  /// Function to create markers.
  MapMarker mapMarkerMakeMarkers(dynamic vehicleOrStop, MapBloc mapBloc) {
    switch (vehicleOrStop.runtimeType) {
      case TartuBikeStations:
        {
          final bikeStation = vehicleOrStop as TartuBikeStations;
          return MapMarker(
            markerType: MarkerType.bike,
            key: Key(bikeStation.id),
            height: 65,
            width: 65,
            builder: (context) => BikeMarker(
              bikeStation: bikeStation,
              mapBloc: mapBloc,
            ),
            point: LatLng(bikeStation.latitude, bikeStation.longitude),
          );
        }
      case BoltScooter:
        {
          final scooter = vehicleOrStop as BoltScooter;
          return MapMarker(
            markerType: MarkerType.scooter,
            key: Key(scooter.id),
            height: 65,
            width: 65,
            builder: (context) => ScooterMarker(
              scooter: scooter,
              mapBloc: mapBloc,
              scooterImagePath: 'assets/bolt_scooter.png',
            ),
            point: LatLng(scooter.latitude, scooter.longitude),
          );
        }
      case TuulScooter:
        {
          final scooter = vehicleOrStop as TuulScooter;
          return MapMarker(
            markerType: MarkerType.scooter,
            key: Key(scooter.id),
            height: 65,
            width: 65,
            builder: (context) => ScooterMarker(
              scooter: scooter,
              mapBloc: mapBloc,
              scooterImagePath: 'assets/tuul_scooter.png',
            ),
            point: LatLng(scooter.lat, scooter.lon),
          );
        }
      case HoogScooter:
        {
          final scooter = vehicleOrStop as HoogScooter;
          return MapMarker(
            markerType: MarkerType.scooter,
            key: Key(scooter.id),
            height: 65,
            width: 65,
            builder: (context) => ScooterMarker(
              scooter: scooter,
              mapBloc: mapBloc,
              scooterImagePath: 'assets/hoog_scooter.png',
            ),
            point: LatLng(scooter.latitude, scooter.longitude),
          );
        }
      case BoltCar:
        {
          final car = vehicleOrStop as BoltCar;
          return MapMarker(
            markerType: MarkerType.scooter,
            key: Key(car.id),
            height: 65,
            width: 65,
            builder: (context) => CarMarker(
              car: car,
              mapBloc: mapBloc,
              carImagePath: 'assets/bolt_car.png',
            ),
            point: LatLng(car.latitude, car.longitude),
          );
        }
      case Stop:
        {
          final stop = vehicleOrStop as Stop;
          return MapMarker(
            markerType: MarkerType.stop,
            key: Key(stop.stopId),
            height: 55,
            width: 55,
            builder: (context) => StopMarker(
              mapBloc: mapBloc,
              stop: stop,
            ),
            point: LatLng(stop.latitude, stop.longitude),
          );
        }
    }
    _log.severe('Adding empty marker, something went terribly wrong, check ASAP.');
    return mapMarker;
  }
}
