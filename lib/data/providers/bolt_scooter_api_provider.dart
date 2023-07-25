// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import '../../constants/api_links.dart';
import '../../constants/constants.dart';
import '../../exceptions/exceptions.dart';
import '../models/scooter/bolt_scooter.dart';

/// Methods to do operations with Bolt scooter API provider.
class BoltScooterApiProvider {
  /// Fetch data about Tuul scooters from server.
  Future<(BoltScootersList boltScootersList, String pricePerMinute)> getBoltScooters(String pickedCity) async {
    final identifier = await UniqueIdentifier.serial;
    final deviceInfo = DeviceInfoPlugin();
    if (!Platform.isAndroid) {
      throw const DeviceIsNotSupported();
    }
    const os = 'android';
    final androidInfo = await deviceInfo.androidInfo;
    log('Running on ${androidInfo.model} ${androidInfo.version.release}');
    var lat = '';
    var lon = '';
    final coordinates = cityCoordinates[pickedCity];
    if (coordinates == null) {
      throw const CityIsNotPicked();
    }
    lat = coordinates.latitude.toString();
    lon = coordinates.longitude.toString();
    final param = <String, dynamic>{
      'lat': lat,
      'lng': lon,
      'select_all': 'true',
      'version': 'CA.71.0',
      'deviceId': {identifier},
      'device_name': {androidInfo.model},
      'device_os_version': {androidInfo.version.release},
      'deviceType': {os},
      'country': 'ee',
      'language': 'en',
    };
    try {
      final apiLinks = GetIt.instance<ApiLinks>();
      final response = await http.get(
        Uri.parse(apiLinks.boltScooterLink).replace(queryParameters: param),
        headers: apiLinks.boltHeader,
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final pricePerMinute = jsonData['data']['categories'][0]['price_rate']['duration_rate_str'] as String;

        final vehiclesData = jsonData['data']['categories'][0]['vehicles'] as List<dynamic>;
        final vehicles = vehiclesData
            .map(
              (vehicleData) =>
                  BoltScooter.fromJson(vehicleData as Map<String, dynamic>),
            )
            .toList();
        return (vehicles, pricePerMinute);
      } else {
        throw const CantFetchBoltScootersData();
      }
    } on SocketException {
      throw const NoInternetConnection();
    } catch (e) {
      rethrow;
    }
  }
}
