import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobility_app/number_on_marker.dart';
import 'package:mobility_app/tartu_bikes.dart';
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
  Map<String, Marker> _markers = {};
  bool scooterState = true;
  bool bikeState = true;

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List scooterMarker = await getBytesFromAsset(
      path: 'assets/scooter.png',
      width: 75,
    );
    final scootersLocations = await getBoltScooters();
    final bikeLocations = await getTartuBikes();
    for (final scooter in scootersLocations) {
      final marker = Marker(
        icon: BitmapDescriptor.fromBytes(scooterMarker),
        markerId: MarkerId(scooter.name),
        position: LatLng(scooter.latitude, scooter.longitude),
        infoWindow: InfoWindow(
          title: scooter.name,
          snippet: scooter.charge.toString(),
        ),
      );
      _markers[scooter.name] = marker;
    }
    for (final bike in bikeLocations) {
      NumberOnMarker numberOnMarker = NumberOnMarker();
      await numberOnMarker.createMarkerIconFromText(bike.totalLockedCycleCount.toString()).then(
        (BitmapDescriptor bitmap) {
          final marker = Marker(
            icon: bitmap,
            markerId: MarkerId(bike.name),
            position: LatLng(bike.latitude, bike.longitude),
            infoWindow: InfoWindow(
              title: bike.name,
            ),
            onTap: () {
              showModalBottomSheet(
                barrierColor: Colors.white.withOpacity(0),
                context: context,
                builder: (context) {
                  Future<SingleBikeStation> singleBikeStation = getBikeInfo(bike.id);
                  return FutureBuilder<SingleBikeStation>(
                    future: singleBikeStation,
                    builder: (BuildContext buildContext, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        return Container(
                          color: Colors.red, // Display an error message with red background
                          height: 100,
                          width: double.infinity,
                          child: Center(child: Text('Error: ${asyncSnapshot.error}')),
                        );
                      }

                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.white12, // Display a loading indicator with grey background
                          height: 100,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      SingleBikeStation data = asyncSnapshot.data;
                      print('ReRepeat');
                      return Container(
                        color: Colors.green[200],
                        height: 100,
                        width: double.infinity,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Pedelec Bikes: ${data.pedelecCount.toString()}'),
                            Text('Bikes: ${data.bikeCount.toString()}')
                          ],
                        )),
                      );
                    }
                  );
                },
              );
            },
          );
          _markers[bike.name] = marker;
        },
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Office Locations'),
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(58.37, 26.73),
          zoom: 14,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: () {
            setState(() {
              _markers.updateAll((key, marker) {
                if (marker.markerId.value.contains('XXX')) {
                  return marker.copyWith(visibleParam: !scooterState);
                }
                return marker;
              });
              scooterState = !scooterState;
            });
          },child: Icon(Icons.electric_scooter),),
          SizedBox(height: 10,),
          FloatingActionButton(onPressed: () {
            setState(() {
              _markers.updateAll((key, marker) {
                if (!marker.markerId.value.contains('XXX')) {
                  return marker.copyWith(visibleParam: !bikeState);
                }
                return marker;
              });
              bikeState = !bikeState;
            });
          },child: Icon(Icons.pedal_bike),),
        ],
      ),
    );
  }
}
