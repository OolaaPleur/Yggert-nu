import 'package:flutter/material.dart';
import 'package:mobility_app/bolt_scooters.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Scooter ID: ${boltScooter.name.toString()}'),
                  Text('Battery Charge: ${boltScooter.charge.toString()}'),
                ],
              ),
              IconButton(
                  onPressed: () {
                    launchUrl(Uri.parse('bolt://action/scootersSearch'));
                  },
                  icon: const Icon(
                    Icons.electric_scooter,
                    size: 60,
                  ))
            ],
          ),
        ],
      )),
    );
  }
}
