import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/providers/estonia_public_transport_api_provider.dart';

import '../../domain/bolt_scooter.dart';
import '../../domain/estonia_public_transport.dart';
import '../../domain/tartu_bike_station.dart';
import '../data_sources/gtfs_file_source.dart';
import '../providers/bolt_scooter_api_provider.dart';
import '../providers/tartu_bike_station_api_provider.dart';

/// Repository for all transport-related functions.
class VehicleRepository {
  /// Constructor for [VehicleRepository].
  /// Bolt scooters.
  final boltScooterApiProvider = GetIt.I<BoltScooterApiProvider>();

  /// Tartu bikes.
  final tartuBikeStationApiProvider = GetIt.I<TartuBikeStationApiProvider>();
  /// Operations with GTFS files.
  final gtfsFileSource = GetIt.I<GTFSFileSource>();

  /// Estonian public transport.
  final estoniaPublicTransportApiProvider = GetIt.I<EstoniaPublicTransportApiProvider>();

  /// Fetches Bolt scooters data.
  Future<List<BoltScooter>> getBoltScooters(String pickedCity) =>
      boltScooterApiProvider.getBoltScooters(pickedCity);

  /// Fetches Tartu bikes data.
  Future<List<TartuBikeStations>> getTartuBikes() => tartuBikeStationApiProvider.getTartuBikes();

  /// Fetches data for individual bike station.
  Future<SingleBikeStation> getBikeInfo(String bikeId) =>
      tartuBikeStationApiProvider.getBikeInfo(bikeId);

  /// Fetches GTFS data from the internet.
  Future<String> fetchGtfsData() => estoniaPublicTransportApiProvider.fetchData();

  /// Parsing stops.txt and returning List of [Stop].
  Future<List<Stop>> getStops() => gtfsFileSource.parseStops();

  /// Parsing calendar.txt and returning List of [Calendar].
  Future<List<Calendar>> getCalendar() => gtfsFileSource.parseCalendar();

  /// Parsing stoptimes.txt into stop_times.db.
  Future<void> parseStopTimes() => estoniaPublicTransportApiProvider.parseStopTimes();

  /// Parsing trips.txt into trips.db.
  Future<void> parseTrips(List<Calendar> calendar) =>
      estoniaPublicTransportApiProvider.parseTrips(calendar);

  /// Parsing routes.txt into routes.db.
  Future<void> parseRoutes() => estoniaPublicTransportApiProvider.parseRoutes();
}
