import 'package:mobility_app/map/bloc/map_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Here we set and get shared preferences values. We set them in settings
/// screen and get them in BLoC.
class DeviceSettings {

  /// Set [value] for specified [valueKey].
  Future<bool> setValue(String valueKey, String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(valueKey, value);
  }

  /// Get value by its [valueKey].
  Future<String> getValue(String valueKey) async {
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
    return '';
  }
}
