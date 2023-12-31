import 'package:flutter/material.dart';
import 'package:yggert_nu/utils/service_locator.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServicesLocator(
    isProductionForTartuBikesLink: false,
    isProductionForBoltScooterLink: false,
    isProductionForGtfsLink: true,
    isProductionForTuulScooterLink: false,
      isProductionForGeolocation: true,
    isProductionHoogScooterLink: false,
    isProductionBoltCarsLink: false,
  );
  await bootstrap();
}
