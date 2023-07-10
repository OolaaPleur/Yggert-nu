// ignore_for_file: avoid_dynamic_calls
/// Tartu bike station model.
class TartuBikeStations {

  /// Tartu bike station model constructor.
  TartuBikeStations(
      {required this.id,
        required this.name,
        required this.latitude,
        required this.longitude,
        required this.totalLockedCycleCount,});

  /// Deserialize data into bike station object
  factory TartuBikeStations.fromJson(Map<String, dynamic> json) {
    return TartuBikeStations(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: json['areaCentroid']['latitude'] as double,
      longitude: json['areaCentroid']['longitude'] as double,
      totalLockedCycleCount: json['totalLockedCycleCount'] as int,
    );
  }
  /// Tartu bike station ID (e.g. "6beda072-5062-4dc9-989d-0b3b81360186").
  final String id;
  /// Tartu bike station name (e.g. "AHHAA").
  final String name;
  /// Tartu bike station latitude coordinate.
  final double latitude;
  /// Tartu bike station longitude coordinate.
  final double longitude;
  /// All locked cycles on particular Tartu bike station
  final int totalLockedCycleCount;
}

/// Single Tartu  bike station model.
class SingleBikeStation {
/// Single Tartu bike station model constructor.
  SingleBikeStation({required this.bikeCount, required this.pedelecCount});
  /// Number of cycling bikes on station.
  final int bikeCount;
  /// Number of pedelec (electric) bikes on station.
  final int pedelecCount;
}
