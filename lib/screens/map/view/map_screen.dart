import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobility_app/constants/constants.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';
import 'package:mobility_app/widgets/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../theme/bloc/theme_state.dart';
import '../bloc/map_bloc.dart';

/// [MapScreen] widget shows map.
class MapScreen extends StatefulWidget {
  /// The default constructor for the [MapScreen] widget.
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
    _followCurrentLocationStreamController.add(16);
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  Future<void> requestPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted
    } else if (status.isDenied || status.isPermanentlyDenied) {
      showSnackBar();
    }
  }

  void showSnackBar () {
    final mySnackBar =
    AppSnackBar(context, infoMessage: InfoMessage.geolocationPermissionDenied);
    ScaffoldMessenger.of(context).showSnackBar(mySnackBar.showSnackBar());
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<MapBloc>(context).state.status == MapStateStatus.initial) {
      BlocProvider.of<MapBloc>(context).add(const MapMarkersPlacingOnMap());
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(58.37, 26.73),
        zoom: 14,
        maxZoom: 18,
        minZoom: 8,
        interactiveFlags:
            InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.flingAnimation,
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture && _followOnLocationUpdate != FollowOnLocationUpdate.never) {
            setState(
              () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
            );
          }
        },
      ),
      nonRotatedChildren: [
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.mapScreenGpsFAB,
            onPressed: () async {
              // Follow the location marker on the map when location updated until user interact with the map.
              setState(
                () => _followOnLocationUpdate = FollowOnLocationUpdate.always,
              );
              await requestPermission(context);
            },
            child: const Icon(
              Icons.my_location,
            ),
          ),
        ),
      ],
      children: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return TileLayer(
              // For release, write in doc file for me.
              //urlTemplate:context.read<ThemeBloc>().isDarkModeEnabled ? 'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/{z}/{x}/{y}?access_token=${mapBoxToken}' : 'https://api.mapbox.com/styles/v1/mapbox/light-v11/tiles/{z}/{x}/{y}?access_token=${Env.MAP_BOX_TOKEN}',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.oolaa.redefined.mobility.mobility_app',
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileBuilder: context.read<ThemeBloc>().isDarkModeEnabled ? darkModeTileBuilder : null,
              backgroundColor:
                  context.read<ThemeBloc>().isDarkModeEnabled ? Colors.black54 : Colors.white,
            );
          },
        ),
        CurrentLocationLayer(
          //followOnLocationUpdate: FollowOnLocationUpdate.once,
          followCurrentLocationStream: _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,
          style: const LocationMarkerStyle(
            marker: DefaultLocationMarker(
              child: Icon(
                Icons.gps_not_fixed_rounded,
                color: Colors.white,
              ),
            ),
            markerSize: Size(40, 40),
            showHeadingSector: false,
          ),
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 125,
            disableClusteringAtZoom: 17,
            size: const Size(40, 40),
            markers: context.select((MapBloc bloc) => bloc.state.filteredMarkers),
            anchor: AnchorPos.align(AnchorAlign.center),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(50),
              maxZoom: 20,
            ),
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue[300],
                ),
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
  }
}
