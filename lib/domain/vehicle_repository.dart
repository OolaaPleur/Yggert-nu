import 'package:mobility_app/domain/estonia_public_transport/estonia_public_transport_api_provider.dart';

import 'bolt_scooter/bolt_scooter.dart';
import 'bolt_scooter/bolt_scooter_api_provider.dart';
import 'estonia_public_transport/estonia_public_transport.dart';
import 'tartu_bike_station/tartu_bike_station.dart';
import 'tartu_bike_station/tartu_bike_station_api_provider.dart';

class VehicleRepository {
  final BoltScooterApiProvider _boltScooterApiProvider = BoltScooterApiProvider();

  Future<List<BoltScooter>> getBoltScooters() => _boltScooterApiProvider.getBoltScooters();

  final TartuBikeStationApiProvider _tartuBikeStationApiProvider = TartuBikeStationApiProvider();

  Future<List<TartuBikeStations>> getTartuBikes() => _tartuBikeStationApiProvider.getTartuBikes();

  Future<SingleBikeStation> getBikeInfo(String bikeId) =>
      _tartuBikeStationApiProvider.getBikeInfo(bikeId);

  final EstoniaPublicTransportApiProvider _estoniaPublicTransportApiProvider =
      EstoniaPublicTransportApiProvider();

  // Check file existence
  Future<bool> checkFileExistence() => _estoniaPublicTransportApiProvider.checkFileExistence();

  //Stops

  Future<void> fetchGtfsData() => _estoniaPublicTransportApiProvider.fetchData();

  Future<List<Stop>> parseStops() => _estoniaPublicTransportApiProvider.parseStops();

  //StopTimes

  List<StopTime> getStopTimesForOneStop(String stopId, List<StopTime> stopTimeList) =>
      _estoniaPublicTransportApiProvider.getStopTimesForOneStop(stopId, stopTimeList);

  Future<List<StopTime>> parseStopTimes(List<Trip> trips) =>
      _estoniaPublicTransportApiProvider.parseStopTimes(trips);

  //Trips

  Future<List<Trip>> parseTrips(List<Calendar> calendar) =>
      _estoniaPublicTransportApiProvider.parseTrips(calendar);

  List<Trip> getTripsForOneStopForAllStopTimes(
    List<StopTime> stopTimeListForOneStop,
    List<Trip> allTrips,
  ) =>
      _estoniaPublicTransportApiProvider.getTripsForOneStopForAllStopTimes(
          stopTimeListForOneStop, allTrips,);

  List<Calendar> getCalendarForService(String serviceId, List<Calendar> allCalendars) =>
      _estoniaPublicTransportApiProvider.getCalendarForService(serviceId, allCalendars);

  Future<List<Calendar>> parseCalendar() => _estoniaPublicTransportApiProvider.parseCalendar();

  String getDaysOfWeekString(List<Calendar> tripCalendars) =>
      _estoniaPublicTransportApiProvider.getDaysOfWeekString(tripCalendars);
}
