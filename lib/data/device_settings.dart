import 'dart:ui';

import 'package:mobility_app/screens/map/bloc/map_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

/// Here we set and get shared preferences values. We set them in settings
/// screen and get them in BLoC.
class DeviceSettings {

  /// Set String [value] for specified [valueKey].
  Future<bool> setStringValue(String valueKey, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      final existingValue = await getStringValue(valueKey);
      return prefs.setString(valueKey, existingValue);
    }

    return prefs.setString(valueKey, value);
  }

  /// Set bool [value] for specified [valueKey].
  Future<bool> setBoolValue(String valueKey, {bool? value}) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      final existingValue = await getBoolValue(valueKey);
      return prefs.setBool(valueKey, existingValue);
    }

    return prefs.setBool(valueKey, value);
  }

  /// Get value by its [valueKey].
  Future<String> getStringValue(String valueKey) async {
    final prefs = await SharedPreferences.getInstance();

    if (valueKey == 'userTripsFilterValue') {
    return prefs.getString(valueKey) ?? GlobalShowTripsForToday.all.name;
    }
    if (valueKey == 'pickedCity') {
      return prefs.getString(valueKey) ?? City.tartu.name;
    }
    if (valueKey == 'gtfs_download_date') {
      return prefs.getString(valueKey) ?? 'no data';
    }
    if (valueKey == 'language_code') {
      return prefs.getString(valueKey) ?? PlatformDispatcher.instance.locales.first.languageCode;
    }
    return '';
  }
  /// Get String value by its [valueKey].
  Future<bool> getBoolValue(String valueKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (valueKey == 'isDark') {
      return prefs.getBool(valueKey) ?? false;
    }
    if (valueKey == 'low_charge_scooter_visibility') {
      return prefs.getBool(valueKey) ?? true;
    }
    if (valueKey == 'tutorial_passed') {
      return prefs.getBool(valueKey) ?? false;
    }
    if (valueKey == 'first_load') {
      return prefs.getBool(valueKey) ?? false;
    }
    return false;
  }
}
