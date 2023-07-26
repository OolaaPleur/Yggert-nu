import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api_links.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/exceptions.dart';
import '../../models/scooter/hoog_scooter.dart';
/// Methods to do operations with Hoog scooter API provider.
class HoogScooterApiProvider {
  /// Fetch data about Hoog scooters from server.
  Future <List<HoogScooter>> getHoogScooters() async {
    try {
      final apiLinks = GetIt.instance<ApiLinks>();
      final response = await http.get(
        Uri.parse(apiLinks.hoogScooterLink),
        headers: hoogHeader,
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final vehiclesData = jsonData['vehicles'] as List<dynamic>;
        try {
          final vehicles = vehiclesData
              .map(
                (vehicleData) => HoogScooter.fromJson(vehicleData as Map<String, dynamic>),
          )
              .toList();
          return vehicles;
        } catch (e) {
          rethrow;
        }
      } else {
        throw const CantFetchHoogScootersData();
      }
    } on SocketException {
      throw const NoInternetConnection();
    } catch (e) {
      rethrow;
    }
  }
}
