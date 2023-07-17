/// Class, needed to specify, which links we use right now from test links
/// and which from production.
class ApiLinks {
  /// Constructor for [ApiLinks].
  ApiLinks({
    required this.tartuBikesLink,
    required this.boltScooterLink,
    required this.gtfsLink,
    required this.boltHeader,
    required this.tuulScooterLink,
  });

  /// Link to Tartu bikes API.
  final String tartuBikesLink;

  /// Link to Bolt scooters API.
  final String boltScooterLink;
  /// Link to Tuul scooters API.
  final String tuulScooterLink;

  /// Link to estonian public transport GTFS data.
  final String gtfsLink;

  /// Header for Bolt API request.
  final Map<String, String> boltHeader;
}

/// Method for getting API links.
({
  String tartuBikesLink,
  String boltScooterLink,
  String gtfsLink,
  Map<String, String> boltHeader,
  String dummyLink,
  String tuulScooterLink,
}) getApiLinks = (
  tartuBikesLink: 'https://api.ratas.tartu.ee/cxf/am/',
  boltScooterLink: 'https://user.live.boltsvc.net/micromobility/search/getVehicles',
  gtfsLink: 'http://www.peatus.ee/gtfs/gtfs.zip',
  boltHeader: {
    'Authorization': 'Basic KzM3MjUzMjY5NjIyOjQxNTlhZWE3LTBlMjEtNGI2Mi05ZmQ1LTg0MmM1NjdhZWRhOQ=='
  },
  dummyLink: 'https://dummyjson.com/notfound',
  tuulScooterLink:
      'https://enduser-gateway-dot-comodule-fleet.ew.r.appspot.com/api/public/vehicles/by-categories',
);
