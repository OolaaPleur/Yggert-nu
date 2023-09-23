// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:yggert_nu/data/models/scooter/tuul_scooter.dart';

import '../../../constants/api_links.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/exceptions.dart';

/// Methods to do operations with Tuul scooter API provider.
class TuulScooterApiProvider {
  /// Fetch data about Tuul scooters from server.
  Future<
      (
        List<TuulScooter> tuulScootersList, {
        String pricePerMinute,
        String startPrice,
        String reservePrice
      })> getTuulScooters(String pickedCity) async {
    final area = cityTuulAreas[pickedCity];
    if (area == null) {
      throw const CityIsNotPicked();
    }
    final param = <String, dynamic>{'area': area};
    try {
      final apiLinks = GetIt.instance<ApiLinks>();

      final response = await http.get(
        Uri.parse(apiLinks.tuulScooterLink).replace(queryParameters: param), headers: {      'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': '*/*',},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final categoriesData = jsonData['categories'] as List<dynamic>;
        final vehiclesData = categoriesData[0]['vehicles'] as List<dynamic>;

        final durationRateStr = categoriesData[0]['pricing']['string']['en'] as String;
        final regExp = RegExp(r'(\d+.\d+€)');
        final matches = regExp.allMatches(durationRateStr);

        final prices = matches.map((match) => match.group(0)).toList();

        try {
          final startPrice = prices[0]!; // '0.00€'
          final pricePerMinute = prices[1]!; // '0.20€'
          final reservePrice = prices[2]!; // '0.15€'

          final vehicles = vehiclesData
              .map(
                (vehicleData) => TuulScooter.fromJson(vehicleData as Map<String, dynamic>),
              )
              .toList();
          return (
            vehicles,
            pricePerMinute: pricePerMinute,
            startPrice: startPrice,
            reservePrice: reservePrice
          );
        } catch (e) {
          rethrow;
        }
      } else {
        throw const CantFetchTuulScootersData();
      }
    } on SocketException {
      throw const NoInternetConnection();
    } catch (e) {
      rethrow;
    }
  }
}
