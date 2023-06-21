import 'dart:convert';

import 'package:unique_identifier/unique_identifier.dart';

import 'package:http/http.dart' as http;

import '../../links/links.dart';
import 'bolt_scooter.dart';

class BoltScooterApiProvider {
  Future<List<BoltScooter>> getBoltScooters() async {
    var identifier = await UniqueIdentifier.serial;
    final Map<String, dynamic> param = {
      "lat": "58.371536",
      "lng": "26.78707",
      "select_all": "true",
      "version": "CA.71.0",
      "deviceId": {identifier},
      "device_name": "GooglePixel 5",
      "device_os_version": "12",
      "deviceType": "android",
      "country": "ee",
      "language": "ru",
    };
    final response = await http.get(
        Uri.parse(Links.boltScooterLink).replace(queryParameters: param),
        headers: Links.boltHeader);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> vehiclesData =
          jsonData['data']['categories'][0]['vehicles'];
      List<BoltScooter> vehicles = vehiclesData
          .map((vehicleData) => BoltScooter.fromJson(vehicleData))
          .toList();
      return vehicles;
    } else {
      throw Exception('Error fetching Bolt scooters');
    }
  }
}
