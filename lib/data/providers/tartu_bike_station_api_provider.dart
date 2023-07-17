// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_links.dart';
import '../../exceptions/exceptions.dart';
import '../models/tartu_bike_station.dart';

/// Methods to do operations with Tartu bike station API provider.
class TartuBikeStationApiProvider {
  /// Fetch data about Tartu bike stations from server.
  Future<List<TartuBikeStations>> getTartuBikes() async {
    final bodyMap = json.encode({
      'isPublic': 'true',
      'limit': '-1',
    });

    try {
      final apiLinks = GetIt.instance<ApiLinks>();
      final responseMap = await http.post(
        Uri.parse('${apiLinks.tartuBikesLink}station/map/search'),
        headers: {'Content-Type': 'application/json'},
        body: bodyMap,
      );

      if (responseMap.statusCode == 200) {
        final jsonData = jsonDecode(responseMap.body) as Map<String, dynamic>;
        final vehiclesData = jsonData['results'] as List<dynamic>;
        final vehicles = vehiclesData
            .map((vehicleData) => TartuBikeStations.fromJson(vehicleData as Map<String, dynamic>))
            .toList();
        return vehicles;
      }
      throw const CantFetchTartuSmartBikeData();
    } on SocketException {
      throw const NoInternetConnection();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch data about single Tartu bike station from server.
  Future<SingleBikeStation> getBikeInfo(String bikeId) async {
    final apiLinks = GetIt.instance<ApiLinks>();
    final responseSingleStation =
        await http.get(Uri.parse('${apiLinks.tartuBikesLink}station/$bikeId'));

    try {
      if (responseSingleStation.statusCode == 200) {
        final jsonData = jsonDecode(responseSingleStation.body) as Map<String, dynamic>;
        final bikeCount = jsonData['lockedCycleTypeCount'][0]['countPrimary'] +
            jsonData['lockedCycleTypeCount'][0]['countSecondary'] as int;
        final pedelecCount = jsonData['lockedCycleTypeCount'][1]['countPrimary'] +
            jsonData['lockedCycleTypeCount'][1]['countSecondary'] as int;
        final singleBikeStation =
            SingleBikeStation(bikeCount: bikeCount, pedelecCount: pedelecCount);
        return singleBikeStation;
      }
      throw const CantFetchTartuSmartBikeData();
    } catch (e) {
      rethrow;
    }
  }
}
