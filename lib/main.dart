import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps;
import 'package:latlong2/latlong.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:mobility_app/number_on_marker.dart';
import 'package:mobility_app/tartu_bikes.dart';
import 'package:mobility_app/vehicle_marker.dart';
import 'package:mobility_app/widgets/modal_bottom_sheet_bike_station_info.dart';
import 'package:mobility_app/widgets/modal_bottom_sheet_scooter_info.dart';
import 'bolt_scooters.dart';
import 'tartu_bikes.dart';

void main() => runApp(const MyApp());

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
  List<VehicleMarker> _markers = [];
  bool scooterState = true;
  bool bikeState = true;
  bool carState = true;
  bool modalBottomSheetState = false;
  late SingleBikeStation singleBikeStationState;

  @override
  void initState() {
    super.initState();
    _onMapCreated(mapController);
  }

  MapController mapController = MapController();

  String? selectedScooterId;
  String? selectedBikeId;

  Future<void> _onMapCreated(MapController controller) async {
    final scootersLocations = await getBoltScooters();
    final bikeLocations = await getTartuBikes();
    for (final scooter in scootersLocations) {
      final marker = VehicleMarker(
        vehicleType: VehicleType.scooter,
        key: Key(scooter.id.toString()),
        height: 100.0,
        width: 100.0,
        builder: (context) => Container(
          child: TextButton(
            onPressed: () {
              setState(() {
                selectedScooterId = scooter.id.toString();
              });
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ModalBottomSheetScooterInfo(boltScooter: scooter);
                  }).whenComplete(() {
                    selectedScooterId = '';
                setState(() {});
              });
            },
              child: selectedScooterId == scooter.id.toString()
                  ? Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 8, color: Colors.lightGreen)),
                child: Image.asset('assets/scooter.png'),
              )
                  : Container(
                  margin: EdgeInsets.all(20),
                  child: Image.asset('assets/scooter.png',
                      height: 60, width: 60))),
          ),
        point: LatLng(scooter.latitude, scooter.longitude),
      );
      //_markers[scooter.name] = marker;
      _markers.add(marker);
    }
    for (final bike in bikeLocations) {
      NumberOnMarker numberOnMarker = NumberOnMarker();
      final marker = VehicleMarker(
        vehicleType: VehicleType.bike,
        key: Key(bike.id),
        height: 100.0,
        width: 100.0,
        builder: (context) => TextButton(
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
                                child: Text('Error: ${asyncSnapshot.error}')),
                          );
                        }

                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.white12,
                            // Display a loading indicator with grey background
                            height: 100,
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        SingleBikeStation data = asyncSnapshot.data;
                        singleBikeStationState = data;
                        print('ReRepeat');
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
            child: selectedBikeId == bike.id.toString()
                ? Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 8, color: Colors.lightGreen)),
                    child: Image.asset('assets/bicycle.png'),
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset('assets/bicycle.png',
                        height: 60, width: 60))),
        point: LatLng(bike.latitude, bike.longitude),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  List<Marker> filterMarkers(
      bool showCars, bool showScooters, bool showCycles) {
    List<Marker> filteredMarkers = [];
    for (VehicleMarker marker in _markers) {
      if ((showCars && marker.vehicleType == VehicleType.car) ||
          (showScooters && marker.vehicleType == VehicleType.scooter) ||
          (showCycles && marker.vehicleType == VehicleType.bike)) {
        filteredMarkers.add(marker);
      }
    }
    return filteredMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Office Locations'),
        elevation: 2,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(58.37, 26.73),
          zoom: 14,
          maxZoom: 18,
          interactiveFlags: InteractiveFlag.pinchZoom |
              InteractiveFlag.drag |
              InteractiveFlag.flingAnimation,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.oolaa.redefined.mobility.mobility_app',
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 150,
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
                      color: Colors.blue),
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
            backgroundColor: scooterState
                ? Theme.of(context).floatingActionButtonTheme.backgroundColor
                : Theme.of(context).disabledColor,
            onPressed: () {
              setState(() {
                scooterState = !scooterState;
              });
            },
            child: Icon(Icons.electric_scooter),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: bikeState
                ? Theme.of(context).floatingActionButtonTheme.backgroundColor
                : Theme.of(context).disabledColor,
            onPressed: () {
              setState(() {});
              bikeState = !bikeState;
            },
            child: Icon(Icons.pedal_bike),
          ),
        ],
      ),
    );
  }
}
