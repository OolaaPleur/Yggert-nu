import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mobility_app/utils/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/constants.dart';
import '../../../../data/models/car/bolt_car.dart';
import '../../../../data/models/car/car.dart';
import '../../../../data/repositories/vehicle_repository.dart';
import '../../bloc/map_bloc.dart';

/// Modal bottom sheet, which opens on Bolt scooter's marker pressed.
/// If null, returns text with error.
class ModalBottomSheetCarInfo extends StatelessWidget{
  /// Constructor for creating modal bottom sheet.
  const ModalBottomSheetCarInfo({required this.car, required this.mapBloc, super.key});

  /// Car, has info about its name and some other parameters.
  final Car car;

  /// [MapBloc] object, needed for BLoC communication.
  final MapBloc mapBloc;

  Future<void> _deeplinkOrNot() async {
    final log = Logger('_deeplinkOrNot');
    if (car.runtimeType == BoltCar) {
      try {
        await launchUrl(Uri.parse('bolt://action/scootersSearch'));
      } catch (e) {
        await LaunchApp.openApp(
          androidPackageName: boltPackageName,
        );
      }
    } else {
      log.severe('Scooter is not defined.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleRepository = GetIt.I<VehicleRepository>();
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.12,
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
                //   SizedBox(width:100,child: Text('Car ID: ${car.id}'))
                // else
                //   const SizedBox.shrink(),
                pricePerMinuteText(context, vehicleRepository),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _deeplinkOrNot,
            label: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                context.localizations.modalBottomSheetScooterGoToApp(car.companyName),
              ),
            ),
            icon: const Icon(
              Icons.car_rental,
              size: 40,
            ),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(6)),
          ),
        ],
      ),
    );
  }

  /// Defines different price per minute for different scooters.
  Widget pricePerMinuteText(BuildContext context, VehicleRepository vehicleRepository) {
    final log = Logger('pricePerMinuteText');
    if (car.runtimeType == BoltCar) {
      final boltCar = car as BoltCar;
      return Text(
        context.localizations.modalBottomSheetScooterPrice(
          boltCar.pricePerMinute,
        ),
        textAlign: TextAlign.center,
      );
    }else {
      log.severe('Undefined car, critical error.');
      return const SizedBox.shrink();
    }
  }
}
