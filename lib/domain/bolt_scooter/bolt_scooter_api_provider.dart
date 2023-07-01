// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import '../../links/links.dart';
import 'bolt_scooter.dart';

/// Methods to do operations with Bolt scooter API provider.
class BoltScooterApiProvider {
  /// Fetch data about bolt scooters from server.
  Future<List<BoltScooter>> getBoltScooters() async {
    final identifier = await UniqueIdentifier.serial;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      const os = 'android';
      final androidInfo = await deviceInfo.androidInfo;
      log('Running on ${androidInfo.model} ${androidInfo.version.release}');

      final param = <String, dynamic>{
        'lat': '58.371536',
        'lng': '26.78707',
        'select_all': 'true',
        'version': 'CA.71.0',
        'deviceId': {identifier},
        'device_name': {androidInfo.model},
        'device_os_version': {androidInfo.version.release},
        'deviceType': {os},
        'country': 'ee',
        'language': 'en',
      };
      final response = await http.get(
        Uri.parse(Links.boltScooterLink).replace(queryParameters: param),
        headers: Links.boltHeader,
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        final categoriesData = jsonData['data']['categories'] as List<dynamic>;
        final categoryData = categoriesData[0] as Map<String, dynamic>;
        final durationRateStr = categoryData['price_rate']['duration_rate_str'] as String;

        final vehiclesData = jsonData['data']['categories'][0]['vehicles'] as List<dynamic>;
        final vehicles = vehiclesData
            .map((vehicleData) =>
                BoltScooter.fromJson(vehicleData as Map<String, dynamic>, durationRateStr),)
            .toList();
        return vehicles;
      } else {
        throw Exception('Server error. Cant fetch Bolt scooters data. Check your internet connection.');
        //log('no connection to bolt'); FOR TESTING PURPOSE
      }
    }
    return Future<List<BoltScooter>>.value([]);
  }
}
