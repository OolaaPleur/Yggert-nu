import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../domain/bolt_scooter/bolt_scooter.dart';
import '../domain/tartu_bike_station/tartu_bike_station.dart';
import '../domain/vehicle_repository.dart';
import 'modal_bottom_sheet_bike_station_info.dart';
import 'modal_bottom_sheet_scooter_info.dart';

enum MarkerType { person, car, scooter, bike, none }

class MapMarker extends Marker {
  final MarkerType markerType;

  MapMarker({
    required this.markerType,
    width,
    height,
    point,
    builder,
    key,
  }) : super(
          width: width ?? 0,
          height: height ?? 0,
          point: point ?? LatLng(0, 0),
          builder: builder ?? (_) => Container(),
          key: key ?? const Key('no_key_from_server'),
        );

  MapMarker copyWith({
    MarkerType? markerType,
  }) {
    return MapMarker(
      markerType: markerType ?? this.markerType,
    );
  }
}

class CreateMapMarkerList {
  MapMarker mapMarker = MapMarker(markerType: MarkerType.person);

  MapMarker placeUserLocationOnMap (LatLng latLng) {
    mapMarker = MapMarker(
      width: 30.0,
      height: 30.0,
      point: latLng,
      builder: (ctx) => const Icon(
        Icons.gps_fixed,
        size: 50,
        color: Colors.blue,
      ),
      key: const Key('GPS Location of person'),
      markerType: MarkerType.person,
    );
    return mapMarker;
  }

  MapMarker mapMarkerMakeMarkers(dynamic vehicle) {
    switch (vehicle.runtimeType) {
      case TartuBikeStations:
        {
          VehicleRepository tartuBikeStationRepository = VehicleRepository();
          mapMarker = mapMarker.copyWith(markerType: MarkerType.bike);
          mapMarker = MapMarker(
            markerType: MarkerType.bike,
            key: Key(vehicle.id.toString()),
            height: 65.0,
            width: 65.0,
            builder: (context) => TextButton(
              onPressed: () async {
                VehicleRepository bikeInfo =
                    tartuBikeStationRepository;

                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<SingleBikeStation>(
                          future: bikeInfo.getBikeInfo(vehicle.id),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return Container(
                                color: Colors.red,
                                // Display an error message with red background
                                height: 100,
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                        'Error: ${asyncSnapshot.error}')),
                              );
                            }
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                color: Colors.white12,
                                // Display a loading indicator with grey background
                                height: 100,
                                width: double.infinity,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.done) {
                              return ModalBottomSheetBikeStationInfo(
                                  singleBikeStationState: asyncSnapshot.data);
                            }
                            return const SizedBox();
                          });
                    });
              },
              child: Center(
                child: Stack(
                  children: [
                    Image.asset('assets/bicycle.png', height: 60, width: 60),
                    Center(
                      child: Text(
                        vehicle.totalLockedCycleCount.toString(),
                        style: const TextStyle(
                            fontSize: 22, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            point: LatLng(vehicle.latitude, vehicle.longitude),
          );

          /////////////////////////////////////////////////
        }
      case BoltScooter:
        {
          mapMarker = mapMarker.copyWith(markerType: MarkerType.scooter);
          mapMarker = MapMarker(
            markerType: MarkerType.scooter,
            key: Key(vehicle.id.toString()),
            height: 65.0,
            width: 65.0,
            builder: (context) => Stack(
              children: [
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalBottomSheetScooterInfo(
                                boltScooter: vehicle);
                          }).whenComplete(() {});
                    },
                    child: Image.asset(
                      'assets/scooter.png',
                    )),
              ],
            ),
            point: LatLng(vehicle.latitude, vehicle.longitude),
          );
        }
    }
    return mapMarker;
  }
}
