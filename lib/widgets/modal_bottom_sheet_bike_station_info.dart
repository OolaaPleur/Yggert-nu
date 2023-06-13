import 'package:flutter/material.dart';
import 'package:mobility_app/tartu_bikes.dart';

class ModalBottomSheetBikeStationInfo extends StatelessWidget {
  const ModalBottomSheetBikeStationInfo({super.key, required this.singleBikeStationState});

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
              Text(
                  'Pedelec Bikes: ${singleBikeStationState.pedelecCount.toString()}'),
              Text(
                  'Bikes: ${singleBikeStationState.bikeCount.toString()}')
            ],
          )),
    );
  }
}
