import 'package:flutter/material.dart';
import 'package:mobility_app/bolt_scooters.dart';

class ModalBottomSheetScooterInfo extends StatelessWidget {
  const ModalBottomSheetScooterInfo({super.key, required this.boltScooter});

  final BoltScooter boltScooter;

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
                  'Scooter ID: ${boltScooter.name.toString()}'),
              Text(
                  'Battery Charge: ${boltScooter.charge.toString()}')
            ],
          )),
    );
  }
}
