import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport_api_provider.dart';

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
  Future<List<BoltScooter>> getBoltScooters() => _boltScooterApiProvider.getBoltScooters();

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
  Future<void> fetchGtfsData() => _estoniaPublicTransportApiProvider.fetchData();
  /// Parsing stops.txt and returning List of [Stop].
  Future<List<Stop>> parseStops() => _estoniaPublicTransportApiProvider.parseStops();
  /// Parsing stoptimes.txt and returning List of [StopTime].
  Future<void> parseStopTimes() =>
      _estoniaPublicTransportApiProvider.parseStopTimes();
  /// Parsing trips.txt and returning List of [Trip].
  Future<void> parseTrips(List<Calendar> calendar) =>
      _estoniaPublicTransportApiProvider.parseTrips(calendar);
  /// Parsing calendar.txt and returning List of [Calendar].
  Future<List<Calendar>> parseCalendar() => _estoniaPublicTransportApiProvider.parseCalendar();
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
  /// Returns List of [Calendar] for particular serviceId. Function needed to
  /// get list of days, when trip is going.
  List<Calendar> getCalendarForService(String serviceId, List<Calendar> allCalendars) =>
      _estoniaPublicTransportApiProvider.getCalendarForService(serviceId, allCalendars);
  /// Convert Calender List into three-letters human-readable form
  /// (Mon, Tue, Wed etc).
  String getDaysOfWeekString(List<Calendar> tripCalendars) =>
      _estoniaPublicTransportApiProvider.getDaysOfWeekString(tripCalendars);

  // Saving settings to shared preferences.
  DeviceSettings _deviceSettings = DeviceSettings();
  Future<bool> saveValue(String value) => _deviceSettings.saveValue(value);
  Future<String> getValue() => _deviceSettings.getValue();
}
