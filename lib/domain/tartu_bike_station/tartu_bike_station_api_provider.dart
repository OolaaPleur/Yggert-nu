import 'dart:convert';

import '../../links/links.dart';
import 'tartu_bike_station.dart';

import 'package:http/http.dart' as http;

class TartuBikeStationApiProvider {
  Future<List<TartuBikeStations>> getTartuBikes() async {
    String bodyMap = json.encode({
      'isPublic': 'true',
      'limit': '-1',
    });

    http.Response responseMap = await http.post(
      Uri.parse("${Links.tartuBikesLink}station/map/search"),
      headers: {"Content-Type": "application/json"},
      body: bodyMap,
    );

    if (responseMap.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(responseMap.body);
      List<dynamic> vehiclesData = jsonData['results'];
      List<TartuBikeStations> vehicles = vehiclesData
          .map((vehicleData) => TartuBikeStations.fromJson(vehicleData))
          .toList();
      return vehicles;
    }
    throw Exception();
  }

  Future<SingleBikeStation> getBikeInfo(String bikeId) async {
    final responseSingleStation =
    await http.get(Uri.parse('${Links.tartuBikesLink}station/$bikeId'));

    if (responseSingleStation.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(responseSingleStation.body);
      int bikeCount = jsonData['lockedCycleTypeCount'][0]['countPrimary'] +
          jsonData['lockedCycleTypeCount'][0]['countSecondary'];
      int pedelecCount = jsonData['lockedCycleTypeCount'][1]['countPrimary'] +
          jsonData['lockedCycleTypeCount'][1]['countSecondary'];
      SingleBikeStation singleBikeStation =
      SingleBikeStation(bikeCount: bikeCount, pedelecCount: pedelecCount);
      return singleBikeStation;
    }
    throw Exception();
  }
}
