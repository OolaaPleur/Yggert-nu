import 'bolt_scooter/bolt_scooter.dart';
import 'bolt_scooter/bolt_scooter_api_provider.dart';
import 'tartu_bike_station/tartu_bike_station.dart';
import 'tartu_bike_station/tartu_bike_station_api_provider.dart';

class VehicleRepository {
  final BoltScooterApiProvider _boltScooterApiProvider = BoltScooterApiProvider();

  Future<List<BoltScooter>> getBoltScooters() =>
      _boltScooterApiProvider.getBoltScooters();

  final TartuBikeStationApiProvider _tartuBikeStationApiProvider = TartuBikeStationApiProvider();

  Future<List<TartuBikeStations>> getTartuBikes() =>
      _tartuBikeStationApiProvider.getTartuBikes();

  Future<SingleBikeStation> getBikeInfo(String bikeId) =>
      _tartuBikeStationApiProvider.getBikeInfo(bikeId);
}
