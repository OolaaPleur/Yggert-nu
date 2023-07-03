import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/bolt_scooter/bolt_scooter.dart';

/// Modal bottom sheet, which opens on Bolt scooter's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetScooterInfo extends StatelessWidget {
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetScooterInfo({required this.boltScooter, super.key});

  /// Bolt scooter, has info about its name, charge and some other parameters.
  final BoltScooter? boltScooter;

  @override
  Widget build(BuildContext context) {
    return boltScooter == null
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
                          Text('Scooter ID: ${boltScooter!.name}'),
                          Text('Battery Charge: ${boltScooter!.charge}%'),
                          Text('Price: ${boltScooter!.durationRateStr.toLowerCase()}'),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('bolt://action/scootersSearch'));
                            },
                            label: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text('Go to Bolt app'),
                            ),
                            icon: const Icon(
                              Icons.electric_scooter, size: 40,
                            ),style: IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
