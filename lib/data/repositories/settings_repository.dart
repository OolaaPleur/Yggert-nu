import '../device_settings.dart';

/// Class, acts as repository for actions, related to settings (primarily
/// working with shared preferences).
class SettingsRepository {
  // Saving settings to shared preferences.
  final DeviceSettings _deviceSettings = DeviceSettings();

  /// Function save String [value] for specified [valueKey] in shared preferences.
  Future<bool> setStringValue(String valueKey, String value) =>
      _deviceSettings.setStringValue(valueKey, value);

  /// Function save bool [value] for specified [valueKey] in shared preferences.
  Future<bool> setBoolValue(String valueKey, {bool? value}) =>
      _deviceSettings.setBoolValue(valueKey, value: value);

  /// Function get String by its [valueKey] from shared preferences.
  Future<String> getStringValue(String valueKey) => _deviceSettings.getStringValue(valueKey);

  /// Function get bool by its [valueKey] from shared preferences.
  Future<bool> getBoolValue(String valueKey) async => _deviceSettings.getBoolValue(valueKey);
}
