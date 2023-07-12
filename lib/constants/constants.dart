import 'package:flutter/material.dart';

/// Messages, used to control flow of the app.
enum InfoMessage {
  /// Default message, used as initial value in MapState, and used as
  /// fallback value to reset MapState variable.
  defaultMessage,
  /// No need to download GTFS file.
  noNeedToDownload,
  /// Need to download GTFS file.
  needToDownload,
  /// File was successfully downloaded and processed.
  fileDownloadedAndProcessed,
  // Map Screen
  /// Geolocation permission denied by user.
  geolocationPermissionDenied,
}
/// Coordinates of Tartu, used in constructing requests.
const tartuCoordinates = (latitude: 58.371536, longitude: 26.78707);
/// Coordinates of Tallinn, used in constructing requests.
const tallinnCoordinates = (latitude: 59.434360, longitude: 24.747061);

/// Class, stores sizes for widgets.
class AppSizes {
  /// Modal bottom sheet height for rental scooters, bikes etc.
  static double microMobilityModalBottomSheetHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.12;
  }
}
