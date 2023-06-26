import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import '../bloc/map_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
      if (BlocProvider.of<MapBloc>(context).state.status ==
          MapStateStatus.loading) {
        BlocProvider.of<MapBloc>(context).add(const MapMarkersPlacingOnMap());
      }
      return BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(58.37, 26.73),
              zoom: 14,
              maxZoom: 18,
              minZoom: 8,
              interactiveFlags: InteractiveFlag.pinchZoom |
                  InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName:
                    'com.oolaa.redefined.mobility.mobility_app',
              ),
              CurrentLocationLayer(
                followOnLocationUpdate: FollowOnLocationUpdate.once,
                turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.gps_not_fixed_rounded,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: Size(40, 40),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 125,
                  disableClusteringAtZoom: 17,
                  size: const Size(40, 40),
                  markers: state.filteredMarkers,
                  anchor: AnchorPos.align(AnchorAlign.center),
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                    maxZoom: 18,
                  ),
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlue[300]),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );

  }
}
