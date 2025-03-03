import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yggert_nu/constants/constants.dart';
import 'package:yggert_nu/data/models/scooter/hoog_scooter.dart';
import 'package:yggert_nu/data/models/scooter/tuul_scooter.dart';
import 'package:yggert_nu/data/repositories/vehicle_repository.dart';

import '../../../../data/models/scooter/bolt_scooter.dart';
import '../../../../data/models/scooter/scooter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/build_context_ext.dart';
import '../../bloc/map_bloc.dart';

/// Modal bottom sheet, which opens on Bolt scooter's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetScooterInfo extends StatelessWidget {
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetScooterInfo({required this.scooter, required this.mapBloc, super.key});

  /// Bolt scooter, has info about its name, charge and some other parameters.
  final Scooter scooter;

  /// Bloc object, needs to get info about package.
  final MapBloc mapBloc;

  Future<void> _deeplinkOrNot() async {
    final log = Logger('_deeplinkOrNot');
    if (scooter.runtimeType == BoltScooter) {
      if (kIsWeb) {
        await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=ee.mtakso.client&hl=en_US'));
      } else {
        try {
          await launchUrl(Uri.parse('bolt://action/scootersSearch'));
        } catch (e) {
          await LaunchApp.openApp(
            androidPackageName: boltPackageName,
          );
        }
      }
    } else if (scooter.runtimeType == TuulScooter) {
      if (kIsWeb) {
        await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.comodule.fleet&hl=en_US'));
      } else {
        await LaunchApp.openApp(
          androidPackageName: tuulPackageName,
        );
      }
    } else if (scooter.runtimeType == HoogScooter) {
      if (kIsWeb) {
        await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=hoog.app&hl=en_US'));
      } else {
        await LaunchApp.openApp(
          androidPackageName: hoogPackageName,
        );
      }
    } else {
      log.severe('Scooter is not defined.');
    }
  }

  /// Defines container height for different types of scooter.
  double containerHeight(BuildContext context) {
    switch (scooter.runtimeType) {
      case BoltScooter:
        return AppStyleConstants.bikeModalBottomSheetHeight(context);
      case TuulScooter:
        return AppStyleConstants.microMobilityModalBottomSheetHeight(context);
      case HoogScooter:
        return AppStyleConstants.microMobilityModalBottomSheetHeight(context);
    }
    return AppStyleConstants.microMobilityModalBottomSheetHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    late HoogScooter hoogScooter;
    if (scooter is HoogScooter) {
      hoogScooter = scooter as HoogScooter;
    }
    final vehicleRepository = GetIt.I<VehicleRepository>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppStyleConstants.paddingBetweenTextAndScreenModalSheet),
      child: SizedBox(
        height: containerHeight(context),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (kDebugMode)
                  //   SizedBox(width:100,child: Text('Scooter ID: ${scooter.id}'))
                  // else
                  //   const SizedBox.shrink(),
                  Text(
                    context.localizations.modalBottomSheetScooterCharge(scooter.charge),
                    textAlign: TextAlign.center,
                  ),
                  pricePerMinuteText(context, vehicleRepository),
                  if (scooter.runtimeType == TuulScooter)
                    Column(
                      children: [
                        Text(
                          context.localizations.modalBottomSheetScooterStartPrice(
                            vehicleRepository.tuulStartPrice,
                          ),
                        ),
                        Text(
                          context.localizations.modalBottomSheetScooterReservePrice(
                            vehicleRepository.tuulReservePrice,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  if (scooter.runtimeType == HoogScooter)
                    Column(
                      children: [
                        Text(
                          context.localizations.modalBottomSheetScooterPausePrice(
                            hoogScooter.pauseInfo,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: AppStyleConstants.paddingBetweenTextAndButtonModalSheet),
                child: ElevatedButton.icon(
                  onPressed: _deeplinkOrNot,
                  label: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      AppLocalizations.of(context)!.modalBottomSheetScooterGoToApp(scooter.companyName),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  icon: const Icon(
                    Icons.electric_scooter,
                    size: 40,
                  ),
                  style: IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Defines different price per minute for different scooters.
  Widget pricePerMinuteText(BuildContext context, VehicleRepository vehicleRepository) {
    final log = Logger('pricePerMinuteText');
    if (scooter.runtimeType == BoltScooter) {
      return Text(
        AppLocalizations.of(context)!.modalBottomSheetScooterPrice(
          vehicleRepository.boltPricePerMinute,
        ),
        textAlign: TextAlign.center,
      );
    } else if (scooter.runtimeType == TuulScooter) {
      return Text(
        AppLocalizations.of(context)!.modalBottomSheetScooterPrice(
          vehicleRepository.tuulPricePerMinute,
        ),
        textAlign: TextAlign.center,
      );
    }
    else if (scooter.runtimeType == HoogScooter) {
      final hoogScooter = scooter as HoogScooter;
      return Text(
        AppLocalizations.of(context)!.modalBottomSheetScooterPrice(
          hoogScooter.priceInfo,
        ),
        textAlign: TextAlign.center,
      );
    }else {
      log.severe('Undefined scooter, critical error.');
      return const SizedBox.shrink();
    }
  }
}
