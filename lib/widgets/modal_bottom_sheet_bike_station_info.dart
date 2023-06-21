import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

import '../domain/tartu_bike_station/tartu_bike_station.dart';


class ModalBottomSheetBikeStationInfo extends StatelessWidget {
  const ModalBottomSheetBikeStationInfo(
      {super.key, required this.singleBikeStationState});

  final SingleBikeStation singleBikeStationState;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Text(
                        'Pedelec Bikes: ${singleBikeStationState.pedelecCount.toString()}'),
                    Text(
                        'Bikes: ${singleBikeStationState.bikeCount.toString()}'),
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
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
