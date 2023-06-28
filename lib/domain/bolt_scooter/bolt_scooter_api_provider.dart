// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import '../../links/links.dart';
import 'bolt_scooter.dart';

/// Methods to do operations with Bolt scooter API provider.
class BoltScooterApiProvider {
  /// Fetch data about bolt scooters from server.
  Future<List<BoltScooter>> getBoltScooters() async {
    final identifier = await UniqueIdentifier.serial;
    final param = <String, dynamic>{
      'lat': '58.371536',
      'lng': '26.78707',
      'select_all': 'true',
      'version': 'CA.71.0',
      'deviceId': {identifier},
      'device_name': 'GooglePixel 5',
      'device_os_version': '12',
      'deviceType': 'android',
      'country': 'ee',
      'language': 'ru',
    };
    final response = await http.get(
      Uri.parse(Links.boltScooterLink).replace(queryParameters: param),
      headers: Links.boltHeader,
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final vehiclesData = jsonData['data']['categories'][0]['vehicles'] as List<dynamic>;
      final vehicles = vehiclesData
          .map((vehicleData) => BoltScooter.fromJson(vehicleData as Map<String, dynamic>))
          .toList();
      return vehicles;
    } else {
      //throw Exception('Error fetching Bolt scooters');
      log('no connection to bolt');
    }
    return Future<List<BoltScooter>>.value([]);
  }
}
