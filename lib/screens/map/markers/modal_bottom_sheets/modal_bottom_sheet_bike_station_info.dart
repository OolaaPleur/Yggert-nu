import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppStyleConstants.paddingBetweenTextAndScreenModalSheet),
      child: SizedBox(
        height: AppStyleConstants.bikeModalBottomSheetHeight(context),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!
                    .modalBottomSheetTartuBikesPedelecCount(singleBikeStation.pedelecCount),),
                Text(AppLocalizations.of(context)!
                    .modalBottomSheetTartuBikesBikeCount(singleBikeStation.bikeCount),),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: AppStyleConstants.paddingBetweenTextAndButtonModalSheet),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (kIsWeb) {
                      await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.bewegen.tartu&hl=en_US'));
                    } else {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.bewegen.tartu',
                      );
                    }
                  },
                  label: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      AppLocalizations.of(context)!.modalBottomSheetScooterGoToApp(
                        'Tartu bikes',
                      ),
                      textAlign: TextAlign.center,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
