import 'package:flutter/material.dart';
import 'package:mobility_app/utils/service_locator.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServicesLocator(
    isProductionForTartuBikesLink: true,
    isProductionForBoltHeader: true,
    isProductionForBoltScooterLink: true,
    isProductionForGtfsLink: true,
    isProductionForTuulScooterLink: true,
      isProductionForGeolocation: true,
      isProductionForHoogHeader: true,
    isProductionHoogScooterLink: true,
  );
  await bootstrap();
}
