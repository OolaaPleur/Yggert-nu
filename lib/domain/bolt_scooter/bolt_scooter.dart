class BoltScooter {
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

  factory BoltScooter.fromJson(Map<String, dynamic> json) {
    return BoltScooter(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      latitude: json['lat'],
      longitude: json['lng'],
      charge: json['charge'],
      distanceOnCharge: json['distance_on_charge'],
      searchCategoryId: json['search_category_id'],
      primaryAction: json['primary_action'],
    );
  }

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