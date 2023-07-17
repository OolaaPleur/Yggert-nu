import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../data/models/tartu_bike_station.dart';

/// Modal bottom sheet, which opens on bike station's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetBikeStationInfo extends StatelessWidget {
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetBikeStationInfo({required this.singleBikeStation, super.key});

  /// Single bike station, has info about bike and pedelec count.
  final SingleBikeStation singleBikeStation;

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Theme.of(context).primaryColorLight,
            height: AppStyleConstants.bikeModalBottomSheetHeight(context),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( AppLocalizations.of(context)!.modalBottomSheetTartuBikesPedelecCount(singleBikeStation.pedelecCount)),
                    Text( AppLocalizations.of(context)!.modalBottomSheetTartuBikesBikeCount(singleBikeStation.bikeCount)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await LaunchApp.openApp(
                      androidPackageName: 'com.bewegen.tartu',
                    );
                  },
                  label: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      AppLocalizations.of(context)!.modalBottomSheetScooterGoToApp(
                        'Tartu bikes',
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.pedal_bike_sharp,
                    size: 40,
                  ),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(6),
                  ),
                ),
              ],
            ),
          );
  }
}
