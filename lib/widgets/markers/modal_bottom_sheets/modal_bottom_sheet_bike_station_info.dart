import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

import '../../../domain/tartu_bike_station/tartu_bike_station.dart';

/// Modal bottom sheet, which opens on bike station's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetBikeStationInfo extends StatelessWidget {
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetBikeStationInfo({required this.singleBikeStation, super.key});

  /// Single bike station, has info about bike and pedelec count.
  final SingleBikeStation? singleBikeStation;

  @override
  Widget build(BuildContext context) {
    return singleBikeStation == null
        ? const Center(child: Text('Could not load required info'))
        : Container(
            color: Colors.green[200],
            height: 100,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Pedelec Bikes: ${singleBikeStation!.pedelecCount}'),
                          Text('Bikes: ${singleBikeStation!.bikeCount}'),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          await LaunchApp.openApp(
                            androidPackageName: 'com.bewegen.tartu',
                          );
                        },
                        icon: const Icon(
                          Icons.pedal_bike_sharp,
                          size: 60,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
