// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

import '../../../constants/api_links.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/exceptions.dart';
import '../../models/scooter/bolt_scooter.dart';

/// Check OS and coordinates that they are correct.
({double latitude, double longitude}) checkOSAndCoordinates(String pickedCity) {
if (!Platform.isAndroid) {
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
    final identifier = await UniqueIdentifier.serial;
    final deviceInfo = DeviceInfoPlugin();
    const os = 'android';
    final androidInfo = await deviceInfo.androidInfo;
    log('Running on ${androidInfo.model} ${androidInfo.version.release}');
    return {
      'lat': latitude,
      'lng': longitude,
      'select_all': 'true',
      'version': 'CA.76.1',
      'deviceId': {identifier},
      'device_name': {androidInfo.model},
      'device_os_version': {androidInfo.version.release},
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
            jsonData['data']['categories'][0]['price_rate']['duration_rate_str'] as String;

        final vehiclesData = jsonData['data']['categories'][0]['vehicles'] as List<dynamic>;
        final vehicles = vehiclesData
            .map(
              (vehicleData) => BoltScooter.fromJson(vehicleData as Map<String, dynamic>),
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
