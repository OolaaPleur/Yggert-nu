import 'dart:async';

import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport_api_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'bolt_scooter/bolt_scooter.dart';
import 'bolt_scooter/bolt_scooter_api_provider.dart';
import 'device_settings/device_settings.dart';
import 'estonia_public_transport/estonia_public_transport.dart';
import 'tartu_bike_station/tartu_bike_station.dart';
import 'tartu_bike_station/tartu_bike_station_api_provider.dart';

/// Repository for all transport-related functions.
class VehicleRepository {
  // Bolt scooters.
  final BoltScooterApiProvider _boltScooterApiProvider = BoltScooterApiProvider();
  /// Fetches Bolt scooters data.
  Future<List<BoltScooter>> getBoltScooters(String pickedCity) => _boltScooterApiProvider.getBoltScooters(pickedCity);

  // Tartu bikes.
  final TartuBikeStationApiProvider _tartuBikeStationApiProvider = TartuBikeStationApiProvider();
  /// Fetches Tartu bikes data.
  Future<List<TartuBikeStations>> getTartuBikes() => _tartuBikeStationApiProvider.getTartuBikes();
  /// Fetches data for individual bike station.
  Future<SingleBikeStation> getBikeInfo(String bikeId) =>
      _tartuBikeStationApiProvider.getBikeInfo(bikeId);

  // Estonian public transport.
  final EstoniaPublicTransportApiProvider _estoniaPublicTransportApiProvider =
      EstoniaPublicTransportApiProvider();

  /// Check file existence.
  Future<bool> checkFileExistence() => _estoniaPublicTransportApiProvider.checkFileExistence();
  /// Fetches GTFS data from the internet.
  Future<String> fetchGtfsData() => _estoniaPublicTransportApiProvider.fetchData();
  /// Parsing stops.txt and returning List of [Stop].
  Future<List<Stop>> parseStops() => _estoniaPublicTransportApiProvider.parseStops();
  /// Parsing stoptimes.txt into stop_times.db.
  Future<void> parseStopTimes() =>
      _estoniaPublicTransportApiProvider.parseStopTimes();
  /// Parsing trips.txt into trips.db.
  Future<void> parseTrips(List<Calendar> calendar) =>
      _estoniaPublicTransportApiProvider.parseTrips(calendar);
  /// Parsing calendar.txt and returning List of [Calendar].
  Future<List<Calendar>> parseCalendar() => _estoniaPublicTransportApiProvider.parseCalendar();
  /// Parsing routes.txt into routes.db.
  Future<void> parseRoutes() => _estoniaPublicTransportApiProvider.parseRoutes();

  /// Returns List of [StopTime] for one [Stop]
  List<StopTime> getStopTimesForOneStop(String stopId, List<StopTime> stopTimeList) =>
      _estoniaPublicTransportApiProvider.getStopTimesForOneStop(stopId, stopTimeList);
  /// Returns List of [Trip] for one [Stop]
  List<Trip> getTripsForOneStopForAllStopTimes(
    List<StopTime> stopTimeListForOneStop,
    List<Trip> allTrips,
  ) =>
      _estoniaPublicTransportApiProvider.getTripsForOneStopForAllStopTimes(
          stopTimeListForOneStop, allTrips,);
  /// Progress controller for parse stop_times.db
  BehaviorSubject<int> get progressController => _estoniaPublicTransportApiProvider.progressController;

  // Saving settings to shared preferences.
  final DeviceSettings _deviceSettings = DeviceSettings();
  /// Function save [value] for specified [valueKey] in shared preferences.
  Future<bool> setValue(String valueKey, String value) => _deviceSettings.setValue(valueKey, value);
  /// Function get value by its [valueKey] from shared preferences.
  Future<String> getValue(String valueKey) => _deviceSettings.getValue(valueKey);
}
