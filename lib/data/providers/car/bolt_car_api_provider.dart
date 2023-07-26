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
import '../../models/car/bolt_car.dart';
import '../scooter/bolt_scooter_api_provider.dart';

/// Methods to do operations with Bolt car API provider.
class BoltCarApiProvider {
  /// Make parameters for scooter request.
  Future<Map<String, dynamic>> boltCarParameters({
    required String latitude,
    required String longitude,
  }) async {
    final identifier = await UniqueIdentifier.serial;
    final deviceInfo = DeviceInfoPlugin();
    const os = 'android';
    final androidInfo = await deviceInfo.androidInfo;
    log('Running on ${androidInfo.model} ${androidInfo.version.release}');
    return {
      'gps_lat': latitude,
      'gps_lng': longitude,
      'version': 'CA.76.1',
      'deviceId': {identifier},
      'device_name': {androidInfo.model},
      'device_os_version': {androidInfo.version.release},
      'deviceType': {os},
      'country': 'ee',
      'language': 'en',
    };
  }

  /// Fetch data about Bolt cars from server.
  Future<List<BoltCar>> getBoltCars(
      String pickedCity,
      ) async {
    try {
      final coordinates = checkOSAndCoordinates(pickedCity);
      final param = await boltCarParameters(
        latitude: coordinates.latitude.toString(),
        longitude: coordinates.longitude.toString(),
      );
      final apiLinks = GetIt.instance<ApiLinks>();
      final response = await http.post(
        Uri.parse(apiLinks.boltCarsLink).replace(queryParameters: param),
        headers: boltHeader,
        body:
        '{"viewport":{"north_east":{"lat":${coordinates.latitude},"lng":${coordinates.longitude}'
            '},"south_west":{"lat":${coordinates.latitude},"lng":${coordinates.longitude}}}}',
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final vehiclesData = jsonData['data']['categories'] as List<dynamic>;
        final vehicles = <BoltCar>[];
        final priceStrings = <String, String>{};
        for (final vehicleData in vehiclesData) {
          (vehicleData['markers_groups'] as Map<String, dynamic>).forEach((key, value) {
            final priceData = (value['markers'] as List<dynamic>).firstWhere(
                  (marker) => marker['type'] == 'pin_tooltip',
              orElse: () => null,
            );
            if (priceData != null) {
              priceStrings[key] = priceData['content']['subtitle_html'] as String;
            }
          });
          final vehicle = vehicleData['vehicles'] as List<dynamic>;
          vehicles.addAll(
            vehicle.map(
                  (vehicleData) {
                final markersGroupId = vehicleData['markers_group_id'] as String;
                final pricePerMinute = priceStrings[markersGroupId]!.substring(0,5);
                return BoltCar.fromJson(vehicleData as Map<String, dynamic>, pricePerMinute);
              },
            ).toList(),
          );
        }
        return vehicles;
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
