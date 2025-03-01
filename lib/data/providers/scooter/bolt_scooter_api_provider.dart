// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import '../../../constants/api_links.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/exceptions.dart';
import '../../models/scooter/bolt_scooter.dart';

/// Check OS and coordinates that they are correct.
({double latitude, double longitude}) checkOSAndCoordinates(String pickedCity) {
  if (defaultTargetPlatform != TargetPlatform.android && !kIsWeb) {
    throw const DeviceIsNotSupported();
  }
  final coordinates = cityCoordinates[pickedCity];
  if (coordinates == null) {
    throw const CityIsNotPicked();
  }
  return coordinates;
}

/// Methods to do operations with Bolt scooter API provider.
class BoltScooterApiProvider {
  /// Make parameters for scooter request.
  Future<Map<String, dynamic>> boltScooterParameters({
    required String latitude,
    required String longitude,
  }) async {
    String? identifier;
    const os = 'android';
    String? model;
    String? osVersion;
    if (defaultTargetPlatform == TargetPlatform.android) {
      identifier = await UniqueIdentifier.serial;
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      osVersion = androidInfo.version.release;
      log('Running on ${androidInfo.model} ${androidInfo.version.release}');
    }

    if (kIsWeb) {
      identifier = '4fhn49gj30gn38g4';
      model = 'SM-A528B';
      osVersion = '13';
    }
    return {
      'lat': latitude,
      'lng': longitude,
      'select_all': 'true',
      'version': 'CA.76.1',
      'deviceId': {identifier},
      'device_name': {model},
      'device_os_version': {osVersion},
      'deviceType': {os},
      'country': 'ee',
      'language': 'en',
    };
  }

  /// Fetch data about Bolt scooters from server.
  Future<(BoltScootersList boltScootersList, String pricePerMinute)> getBoltScooters(
    String pickedCity,
  ) async {
    try {
      final coordinates = checkOSAndCoordinates(pickedCity);
      final param = await boltScooterParameters(
        latitude: coordinates.latitude.toString(),
        longitude: coordinates.longitude.toString(),
      );
      final apiLinks = GetIt.instance<ApiLinks>();
      final response = await http.get(
        Uri.parse(apiLinks.boltScooterLink).replace(queryParameters: param),
        headers: boltHeader,
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final pricePerMinute =
            jsonData['data']['categories'][2]['price_rate']['duration_rate_str'] as String;

        final categories = jsonData['data']['categories'] as List<dynamic>;

        final vehicles = categories
            .where((category) => (category as Map<String, dynamic>).containsKey('vehicles')) // Ensure it's a Map and has 'vehicles'
            .expand((category) => (category as Map<String, dynamic>)['vehicles'] as List<dynamic>) // Flatten all vehicles
            .map((vehicleData) => BoltScooter.fromJson(vehicleData as Map<String, dynamic>))
            .toList();

        return (vehicles, pricePerMinute);
      } else {
        throw const CantFetchBoltScootersData();
      }
    }
    on SocketException {
      throw const NoInternetConnection();
    }
    catch (e) {
      rethrow;
    }
  }
}
