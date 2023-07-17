import 'package:flutter/material.dart';
import 'package:mobility_app/utils/service_locator.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServicesLocator(
    isProductionForTartuBikesLink: false,
    isProductionForBoltHeader: false,
    isProductionForBoltScooterLink: false,
    isProductionForGtfsLink: true,
    isProductionForTuulScooterLink: false,
  );
  await bootstrap();
}
