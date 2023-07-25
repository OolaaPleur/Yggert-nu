import 'package:mobility_app/data/models/scooter/scooter.dart';

/// Type alias for Bolt scooter list.
typedef BoltScootersList = List<BoltScooter>;

/// Bolt Scooter model.
class BoltScooter extends Scooter {
  /// Bolt Scooter model constructor.
  BoltScooter({
    required String id,
    required int charge,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceOnCharge,
    required this.searchCategoryId,
    required this.primaryAction,
  }) : super(id, charge, 'Bolt');

  /// Deserialize data into Bolt Scooter object.
  factory BoltScooter.fromJson(Map<String, dynamic> json) {
    return BoltScooter(
      id: json['id'].toString(),
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

  /// Scooter name, three X, hyphen and 3 digits (e.g. XXX-111)
  final String name;

  /// Type of transport (scooter)
  final String type;

  /// Scooter latitude coordinate
  final double latitude;

  /// Scooter longitude coordinate
  final double longitude;

  /// Approximate distance it will go on remained charge
  final int distanceOnCharge;

  /// ID(always equals to 75)
  final int searchCategoryId;

  /// Action for scooter (always 'reserve')
  final String primaryAction;
}
