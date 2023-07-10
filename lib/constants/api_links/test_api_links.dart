import 'api_links.dart';

/// Class, which declares links, used for testing purpose.
class TestApiLinks implements ApiLinks {
  @override
  String get tartuBikesLink => 'https://dummyjson.com/notfound';
  @override
  String get boltScooterLink => 'https://dummyjson.com/notfound';
  @override
  String get gtfsLink => 'https://dummyjson.com/notfound';
  @override
  Map<String, String> get boltHeader => {'Authorization': 'Basic KzM3MjUzMjY5NjIyOjQxNTlhZWE3LTBlMjEtNGI2Mi05ZmQ1LTg0MmM1NjdhZWRhOQ=='};
}
