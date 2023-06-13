import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import 'Links/links.dart';

class BoltScooter {
  BoltScooter({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.charge,
    required this.distanceOnCharge,
    required this.searchCategoryId,
    required this.primaryAction,
  });

  factory BoltScooter.fromJson(Map<String, dynamic> json) {
    return BoltScooter(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      latitude: json['lat'],
      longitude: json['lng'],
      charge: json['charge'],
      distanceOnCharge: json['distance_on_charge'],
      searchCategoryId: json['search_category_id'],
      primaryAction: json['primary_action'],
    );
  }

  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final int charge;
  final int distanceOnCharge;
  final int searchCategoryId;
  final String primaryAction;
}

Future<List<BoltScooter>> getBoltScooters() async {
  var identifier = await UniqueIdentifier.serial;
  final Map<String, dynamic> PARAM = {
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
    final response = await http.get(Uri.parse(Links.BOLT_SCOOTERS_LINK).replace(queryParameters: PARAM), headers: Links.BOLT_HEADER);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> vehiclesData = jsonData['data']['categories'][0]['vehicles'];
      List<BoltScooter> vehicles = vehiclesData
          .map((vehicleData) => BoltScooter.fromJson(vehicleData))
          .toList();
      return vehicles;
  }
    throw Exception();
}
