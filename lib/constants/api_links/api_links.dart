/// Links, used in app.
abstract class ApiLinks {
  /// Link to Tartu bikes API.
  String get tartuBikesLink;
  /// Link to Bolt scooters API.
  String get boltScooterLink;
  /// Link to estonian public transport GTFS data.
  String get gtfsLink;
/// Header for Bolt API request.
  Map<String, String> get boltHeader;
}
