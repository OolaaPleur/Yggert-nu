import 'api_links.dart';

/// Class, needed to specify, which links we use right now from test links
/// and which from production.
class CustomApiLinks implements ApiLinks {
  /// Constructor for [CustomApiLinks].
  CustomApiLinks({
    required this.tartuBikesLink,
    required this.boltScooterLink,
    required this.gtfsLink,
    required this.boltHeader,
  });

  @override
  final String tartuBikesLink;

  @override
  final String boltScooterLink;

  @override
  final String gtfsLink;

  @override
  final Map<String, String> boltHeader;
}
