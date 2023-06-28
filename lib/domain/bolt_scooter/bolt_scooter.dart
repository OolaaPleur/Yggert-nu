/// Bolt Scooter model
class BoltScooter {
  /// Bolt Scooter model constructor
  BoltScooter({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.charge,
    required this.distanceOnCharge,
    required this.searchCategoryId,
    required this.primaryAction,
  });

  /// Deserialize data into Bolt Scooter object
  factory BoltScooter.fromJson(Map<String, dynamic> json) {
    return BoltScooter(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      latitude: json['lat'] as double,
      longitude: json['lng'] as double,
      charge: json['charge'] as int,
      distanceOnCharge: json['distance_on_charge'] as int,
      searchCategoryId: json['search_category_id'] as int,
      primaryAction: json['primary_action'] as String,
    );
  }

  /// Scooter ID
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final int charge;
  final int distanceOnCharge;
  final int searchCategoryId;
  final String primaryAction;
}
