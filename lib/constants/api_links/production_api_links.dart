
import 'api_links.dart';
/// Class which declares links used in production.
class ProductionApiLinks implements ApiLinks {
  @override
  String get tartuBikesLink => 'https://api.ratas.tartu.ee/cxf/am/';
  @override
  String get boltScooterLink => 'https://user.live.boltsvc.net/micromobility/search/getVehicles';
  @override
  String get gtfsLink => 'http://www.peatus.ee/gtfs/gtfs.zip';
  @override
  Map<String, String> get boltHeader => {'Authorization': 'Basic KzM3MjUzMjY5NjIyOjQxNTlhZWE3LTBlMjEtNGI2Mi05ZmQ1LTg0MmM1NjdhZWRhOQ=='};
}
