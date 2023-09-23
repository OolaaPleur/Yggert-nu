import 'package:flutter/material.dart';
import 'package:yggert_nu/utils/service_locator.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServicesLocator(
    isProductionForTartuBikesLink: true,
    isProductionForBoltScooterLink: true,
    isProductionForGtfsLink: true,
    isProductionForTuulScooterLink: true,
    isProductionForGeolocation: true,
    isProductionHoogScooterLink: true,
    isProductionBoltCarsLink: true,
  );
  await bootstrap();
}
