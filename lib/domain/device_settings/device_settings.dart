import 'package:shared_preferences/shared_preferences.dart';

class DeviceSettings {
  static const _valueKey = 'userTripsFilterValue';

  Future<bool> saveValue(String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(_valueKey, value);
  }

  Future<String> getValue() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_valueKey) ?? 'all';
  }
}
