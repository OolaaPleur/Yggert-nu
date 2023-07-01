import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport.dart';
import 'package:mobility_app/map/bloc/map_bloc.dart';

import '../domain/bolt_scooter/bolt_scooter.dart';
import '../domain/tartu_bike_station/tartu_bike_station.dart';
import '../domain/vehicle_repository.dart';
import 'markers/bike_marker.dart';
import 'markers/scooter_marker.dart';
import 'markers/stop_marker.dart';

/// Type of the marker.
enum MarkerType {
  /// Public transport stop.
  stop,

  /// Bolt scooter.
  scooter,

  /// Tartu smart bike.
  bike,

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
  /// Create map marker, so after it could be returned.
  MapMarker mapMarker = MapMarker(markerType: MarkerType.none);

  /// Access vehicle repository. In this file it needs it because when user
  /// press the bike station icon, we need to make request to server, to get
  /// info about total count of bikes, as well on pedelec and usual bikes.
  final vehicleRepository = VehicleRepository();

  /// Function to create markers.
  MapMarker mapMarkerMakeMarkers(dynamic vehicleOrStop, MapBloc mapBloc) {
    switch (vehicleOrStop.runtimeType) {
      case TartuBikeStations:
        {
          final bikeStation = vehicleOrStop as TartuBikeStations;
          mapMarker = MapMarker(
            markerType: MarkerType.bike,
            key: Key(bikeStation.id),
            height: 65,
            width: 65,
            builder: (context) => Container(
              margin: context.select(
                (MapBloc bloc) => bloc.state.keyFromOpenedMarker == bikeStation.id,
              )
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(2),
              child: BikeMarker(vehicleRepository: vehicleRepository, bikeStation: bikeStation, mapBloc: mapBloc,),
            ),
            point: LatLng(bikeStation.latitude, bikeStation.longitude),
          );
        }
      case BoltScooter:
        {
          final scooter = vehicleOrStop as BoltScooter;
          mapMarker = MapMarker(
            markerType: MarkerType.scooter,
            key: Key(scooter.id.toString()),
            height: 65,
            width: 65,
            builder: (context) => ScooterMarker(scooter: scooter, mapBloc: mapBloc,),
            point: LatLng(scooter.latitude, scooter.longitude),
          );
        }
      case Stop:
        {
          final stop = vehicleOrStop as Stop;
          mapMarker = MapMarker(
            markerType: MarkerType.stop,
            key: Key(stop.stopId),
            height: 55,
            width: 55,
            builder: (context) => StopMarkerButton(
              mapBloc: mapBloc,
              stop: stop,
            ),
            point: LatLng(stop.latitude, stop.longitude),
          );
        }
    }
    return mapMarker;
  }
}
