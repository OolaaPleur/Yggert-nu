import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobility_app/vehicle_marker.dart';
import 'package:mobility_app/widgets/modal_bottom_sheet_bike_station_info.dart';
import 'package:mobility_app/widgets/modal_bottom_sheet_scooter_info.dart';
import 'bolt_scooters.dart';
import 'tartu_bikes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) => '';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<VehicleMarker> _markers = [];
  bool scooterState = true;
  bool bikeState = true;
  bool carState = true;
  bool modalBottomSheetState = false;
  late SingleBikeStation singleBikeStationState;

  @override
  void initState() {
    super.initState();
    _onMapCreated(mapController);
    _getCurrentLocation();
  }

  MapController mapController = MapController();

  String? selectedScooterId;
  String? selectedBikeId;

  Future<void> _onMapCreated(MapController controller) async {
    final scootersLocations = await getBoltScooters();
    final bikeLocations = await getTartuBikes();

    for (final scooter in scootersLocations) {
      final marker = VehicleMarker(
        markerType: MarkerType.scooter,
        key: Key(scooter.id.toString()),
        height: 65.0,
        width: 65.0,
        builder: (context) => Stack(
          children: [
            selectedScooterId == scooter.id.toString()
                ? Image.asset(
                    'assets/scooter.png',
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        selectedScooterId = scooter.id.toString();
                      });
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalBottomSheetScooterInfo(
                                boltScooter: scooter);
                          }).whenComplete(() {
                        selectedScooterId = '';
                        setState(() {});
                      });
                    },
                    child: Image.asset(
                      'assets/scooter.png',
                    )),
          ],
        ),
        point: LatLng(scooter.latitude, scooter.longitude),
      );
      //_markers[scooter.name] = marker;
      _markers.add(marker);
    }

    for (final bike in bikeLocations) {
      final marker = VehicleMarker(
        markerType: MarkerType.bike,
        key: Key(bike.id),
        height: 65.0,
        width: 65.0,
        builder: (context) => Stack(
          children: [
            selectedBikeId == bike.id.toString()
                ? Image.asset(
                    'assets/bicycle.png',
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        selectedBikeId = bike.id.toString();
                      });
                      showModalBottomSheet(
                        barrierColor: null,
                        context: context,
                        builder: (context) {
                          //Future<SingleBikeStation> singleBikeStation = getBikeInfo(bike.id);
                          if (modalBottomSheetState == true) {
                            return ModalBottomSheetBikeStationInfo(
                                singleBikeStationState: singleBikeStationState);
                          }
                          final bikeId = bike.id;
                          return FutureBuilder<SingleBikeStation>(
                              future: getBikeInfo(bikeId),
                              builder: (BuildContext buildContext,
                                  AsyncSnapshot asyncSnapshot) {
                                modalBottomSheetState = true;
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
                                SingleBikeStation data = asyncSnapshot.data;
                                singleBikeStationState = data;
                                debugPrint('ReRepeat');
                                return ModalBottomSheetBikeStationInfo(
                                    singleBikeStationState: data);
                              });
                        },
                      ).whenComplete(() {
                        modalBottomSheetState = false;
                        selectedBikeId = '';
                        setState(() {});
                      });
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Image.asset('assets/bicycle.png',
                              height: 60, width: 60),
                          Center(
                            child: Text(
                              bike.totalLockedCycleCount.toString(),
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        point: LatLng(bike.latitude, bike.longitude),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    for (final marker in _markers) {
      if (marker.markerType == MarkerType.person) {
        _markers.remove(marker);
        break;
      }
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      LatLng latLng = LatLng(position.latitude, position.longitude);
      mapController.move(latLng, 16);
      setState(() {
        // Update the marker's position
        VehicleMarker updatedMarker = VehicleMarker(
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
        _markers.add(updatedMarker);
        setState(() {});
      });
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user denies the permission
        return;
      }
    }
  }

  List<Marker> filterMarkers(
      bool showCars, bool showScooters, bool showCycles) {
    List<Marker> filteredMarkers = [];
    for (VehicleMarker marker in _markers) {
      if ((showCars && marker.markerType == MarkerType.car) ||
          (showScooters && marker.markerType == MarkerType.scooter) ||
          (showCycles && marker.markerType == MarkerType.bike) ||
          (marker.markerType == MarkerType.person)) {
        filteredMarkers.add(marker);
      }
    }
    return filteredMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tartu Mobility App'),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              _markers.clear();
              setState(() {});
              _onMapCreated(mapController);
            },
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: FlutterMap(
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
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.oolaa.redefined.mobility.mobility_app',
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 125,
              disableClusteringAtZoom: 17,
              size: const Size(40, 40),
              markers: filterMarkers(carState, scooterState, bikeState),
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
      ),
      //
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.lightBlue[300],
            onPressed: () {
              setState(() {
                setState(() {
                  _getCurrentLocation();
                });
              });
            },
            child: const Icon(Icons.gps_fixed_outlined, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: scooterState
                ? Colors.lightBlue[300]
                : Theme.of(context).disabledColor,
            onPressed: () {
              setState(() {
                scooterState = !scooterState;
              });
            },
            child: const Icon(Icons.electric_scooter, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: bikeState
                ? Colors.lightBlue[300]
                : Theme.of(context).disabledColor,
            onPressed: () {
              setState(() {});
              bikeState = !bikeState;
            },
            child: const Icon(Icons.pedal_bike_sharp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
