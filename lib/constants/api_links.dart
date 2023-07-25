import '../utils/env/env.dart';

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
    required this.isProductionForGeolocation,
    required this.hoogHeader,
    required this.hoogScooterLink,
    required this.boltCarsLink,
  });

  /// Link to Tartu bikes API.
  final String tartuBikesLink;

  /// Link to Bolt scooters API.
  final String boltScooterLink;
  /// Link to Bolt scooters API.
  final String hoogScooterLink;
  /// Link to Tuul scooters API.
  final String tuulScooterLink;
  /// Link to Bolt cars API.
  final String boltCarsLink;

  /// Link to estonian public transport GTFS data.
  final String gtfsLink;

  /// Header for Bolt API request.
  final Map<String, String> boltHeader;
  /// Parameter, does app need to show geolocation (used for TEST ONLY and for
  /// tests set to false).
  final bool isProductionForGeolocation;
  /// Header for Hoog API request.
  final Map<String, String> hoogHeader;
}

/// Method for getting API links.
({
  String tartuBikesLink,
  String boltScooterLink,
String hoogScooterLink,
String boltCarsLink,
  String gtfsLink,
  Map<String, String> boltHeader,
Map<String, String> hoogHeader,
  String dummyLink,
  String tuulScooterLink,
}) getApiLinks = (
  tartuBikesLink: 'https://api.ratas.tartu.ee/cxf/am/',
  boltScooterLink: 'https://user.live.boltsvc.net/micromobility/search/getVehicles',
  hoogScooterLink: 'https://app.rideatom.com/api/v1/user/vehicles',
  boltCarsLink: 'https://user.live.boltsvc.net/carsharing/search/getVehicles',
  gtfsLink: 'http://www.peatus.ee/gtfs/gtfs.zip',
  boltHeader: {
    'Authorization': 'Basic ${Env.boltToken}'
  },
hoogHeader: {
  'Authorization': 'Basic ${Env.hoogToken}',
  'app-public-key': Env.hoogAppPublicKey,
  'Host': 'app.rideatom.com',
  'accept': 'application/json',
  'device-os': 'ANDROID',
  'device-os-version': '11',
  'app-version': '6.40',
  'language': 'EN',
  'user-agent': 'okhttp/4.11.0',
},
  dummyLink: 'https://dummyjson.com/notfound',
  tuulScooterLink:
      'https://enduser-gateway-dot-comodule-fleet.ew.r.appspot.com/api/public/vehicles/by-categories',
);
