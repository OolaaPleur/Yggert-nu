import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobility_app/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/bolt_scooter.dart';

/// Modal bottom sheet, which opens on Bolt scooter's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetScooterInfo extends StatelessWidget {
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetScooterInfo({required this.boltScooter, super.key});

  /// Bolt scooter, has info about its name, charge and some other parameters.
  final BoltScooter? boltScooter;

  Future<void> _deeplinkOrNot() async {
    try {
      await launchUrl(Uri.parse('bolt://action/scootersSearch'));
    } catch (e) {
      await LaunchApp.openApp(
        androidPackageName: 'ee.mtakso.client',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return boltScooter == null
        ? Center(child: Text(AppLocalizations.of(context)!.microMobilityCouldNotLoad))
        : Container(
            color: Theme.of(context).primaryColorLight,
            height: AppSizes.microMobilityModalBottomSheetHeight(context),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (kDebugMode)
                      Text('Scooter ID: ${boltScooter!.name}')
                    else
                      const SizedBox.shrink(),
                    Text(
                      AppLocalizations.of(context)!
                          .modalBottomSheetScooterCharge(boltScooter!.charge),
                    ),
                    Text(AppLocalizations.of(context)!
                        .modalBottomSheetScooterPrice(boltScooter!.durationRateStr.toLowerCase(),),),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _deeplinkOrNot,
                  label: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(AppLocalizations.of(context)!
                        .modalBottomSheetScooterGoToApp('Bolt'),),
                  ),
                  icon: const Icon(
                    Icons.electric_scooter,
                    size: 40,
                  ),
                  style: IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                ),
              ],
            ),
          );
  }
}
