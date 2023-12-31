import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:yggert_nu/data/providers/car/bolt_car_api_provider.dart';
import 'package:yggert_nu/data/providers/estonia_public_transport_api_provider.dart';
import 'package:yggert_nu/data/providers/scooter/hoog_scooter_api_provider.dart';
import 'package:yggert_nu/data/providers/scooter/tuul_scooter_api_provider.dart';

import '../../constants/constants.dart';
import '../data_sources/gtfs_file_source.dart';
import '../models/car/bolt_car.dart';
import '../models/estonia_public_transport.dart';
import '../models/scooter/bolt_scooter.dart';
import '../models/scooter/hoog_scooter.dart';
import '../models/scooter/tuul_scooter.dart';
import '../models/tartu_bike_station.dart';
import '../providers/scooter/bolt_scooter_api_provider.dart';
import '../providers/tartu_bike_station_api_provider.dart';

/// Repository for all transport-related functions.
class VehicleRepository {
  /// Constructor for [VehicleRepository].
  /// Bolt scooters.
  final boltScooterApiProvider = GetIt.I<BoltScooterApiProvider>();

  /// Hoog scooters.
  final hoogScooterApiProvider = GetIt.I<HoogScooterApiProvider>();

  /// Tartu bikes.
  final tartuBikeStationApiProvider = GetIt.I<TartuBikeStationApiProvider>();

  /// Bolt cars.
  final boltCarApiProvider = GetIt.I<BoltCarApiProvider>();

  /// Operations with GTFS files.
  final gtfsFileSource = GetIt.I<GTFSFileSource>();

  /// Estonian public transport.
  final estoniaPublicTransportApiProvider = GetIt.I<EstoniaPublicTransportApiProvider>();

  /// Tuul scooters.
  final tuulScooterApiProvider = GetIt.I<TuulScooterApiProvider>();

  /// Holds price for fixed duration (e.g. 0.22/min for Bolt).
  String boltPricePerMinute = '';

  /// Holds price for fixed duration (e.g. 0.20€ for Tuul).
  String tuulPricePerMinute = '';

  /// Start price of scooter.
  String tuulStartPrice = '';

  /// Reserve price for scooter.
  String tuulReservePrice = '';

  /// Fetches Bolt scooters data.
  Future<BoltScootersList> getBoltScooters(String pickedCity) async {
    final (boltScootersList, pricePerMinute) =
        await boltScooterApiProvider.getBoltScooters(pickedCity);
    boltPricePerMinute = pricePerMinute.substring(0, 5);
    return boltScootersList;
  }

  /// Fetches Tuul scooters data.
  Future<List<TuulScooter>> getTuulScooters(String pickedCity) async {
    final (tuulScootersList, :pricePerMinute, :reservePrice, :startPrice) =
        await tuulScooterApiProvider.getTuulScooters(pickedCity);
    tuulPricePerMinute = pricePerMinute;
    tuulStartPrice = startPrice;
    tuulReservePrice = reservePrice;
    return tuulScootersList;
  }

  /// Fetches Tartu bikes data.
  Future<List<TartuBikeStations>> getTartuBikes() => tartuBikeStationApiProvider.getTartuBikes();

  /// Fetches Hoog scooter data.
  Future<List<HoogScooter>> getHoogScooters() => hoogScooterApiProvider.getHoogScooters();

  /// Fetches data for individual bike station.
  Future<SingleBikeStation> getBikeInfo(String bikeId) =>
      tartuBikeStationApiProvider.getBikeInfo(bikeId);

  /// Fetch data about Bolt cars from server.
  Future<List<BoltCar>> getBoltCars(
    String pickedCity,
  ) =>
      boltCarApiProvider.getBoltCars(pickedCity);

  /// Fetches GTFS data from the internet.
  Future<InfoMessage> fetchGtfsData() => estoniaPublicTransportApiProvider.fetchData();

  /// Parsing calendar.txt and returning List of [Calendar].
  Future<List<Calendar>> getCalendar() => gtfsFileSource.parseCalendar();

  /// Parsing stoptimes.txt into stop_times.db.
  Future<void> parseStopTimes() => estoniaPublicTransportApiProvider.parseStopTimes();

  /// Parsing stops.txt and returning List of [Stop].
  Future<List<Stop>> parseStops() => estoniaPublicTransportApiProvider.parseStops();

  /// Parsing trips.txt into trips.db.
  Future<void> parseTrips(List<Calendar> calendar) =>
      estoniaPublicTransportApiProvider.parseTrips(calendar);

  /// Parsing routes.txt into routes.db.
  Future<void> parseRoutes() => estoniaPublicTransportApiProvider.parseRoutes();
}
