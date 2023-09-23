import 'package:yggert_nu/utils/service_locator.dart';

/// Set up service locators for integration testing.
void setUpServiceLocators () {
  setUpServicesLocator(
    isProductionForTartuBikesLink: false,
    isProductionForBoltScooterLink: false,
    isProductionForGtfsLink: false,
    isProductionForTuulScooterLink: false,
    isProductionForGeolocation: false,
    isProductionHoogScooterLink: false,
    isProductionBoltCarsLink: false,
  );
}
