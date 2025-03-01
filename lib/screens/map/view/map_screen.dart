import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yggert_nu/constants/constants.dart';
import 'package:yggert_nu/theme/bloc/theme_bloc.dart';
import 'package:yggert_nu/widgets/snackbar.dart';

import '../../../constants/api_links.dart';
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
  late AlignOnUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = AlignOnUpdate.always;
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

  void showSnackBar() {
    final mySnackBar = AppSnackBar(context, infoMessage: InfoMessage.geolocationPermissionDenied);
    ScaffoldMessenger.of(context).showSnackBar(mySnackBar.showSnackBar());
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider
        .of<MapBloc>(context)
        .state
        .status == MapStateStatus.initial) {
      BlocProvider.of<MapBloc>(context).add(const MapMarkersPlacingOnMap());
    }
    final apiLinks = GetIt.instance<ApiLinks>();

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(58.37, 26.73),
        backgroundColor: context
            .read<ThemeBloc>()
            .isDarkMode ? Colors.black54 : Colors.white,
        initialZoom: 14,
        maxZoom: 18,
        minZoom: 8,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom |
          InteractiveFlag.drag |
          InteractiveFlag.flingAnimation |
          InteractiveFlag.doubleTapZoom,
        ),
        onPositionChanged: (MapCamera position, bool hasGesture) {
          if (hasGesture && _followOnLocationUpdate != AlignOnUpdate.never) {
            setState(
                  () => _followOnLocationUpdate = AlignOnUpdate.never,
            );
          }
        },
      ),
      children: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return TileLayer(
              userAgentPackageName: 'com.oolaa.redefined.mobility.mobility_app',
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileBuilder: context
                  .read<ThemeBloc>()
                  .isDarkMode ? darkModeTileBuilder : null,
            );
          },
        ),
        if (apiLinks.isProductionForGeolocation)
          CurrentLocationLayer(
            //followOnLocationUpdate: FollowOnLocationUpdate.once,
            alignPositionStream: _followCurrentLocationStreamController.stream,
            alignPositionOnUpdate: _followOnLocationUpdate,
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
          )
        else
          const SizedBox.shrink(),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 125,
            disableClusteringAtZoom: 17,
            size: const Size(40, 40),
            markers: context.select((MapBloc bloc) => bloc.state.filteredMarkers),
            alignment: Alignment.center,
            polygonOptions: const PolygonOptions(color: Colors.transparent),
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
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.mapScreenGpsFAB,
            onPressed: () async {
              // Follow the location marker on the map when location updated until user interact with the map.
              await requestPermission(context);
              final positionStream =
              const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
              await positionStream.first.then((position) {
                final newLocation = LatLng(position!.latitude, position.longitude);
                mapController.move(newLocation, mapController.camera.zoom);
              });
              setState(() {
                _followOnLocationUpdate = AlignOnUpdate.always;
              });
            },
            child: const Icon(
              Icons.my_location,
            ),
          ),
        ),
      ],
    );
  }
}
