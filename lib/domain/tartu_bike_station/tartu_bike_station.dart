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
  final String id;
  final String name;
  final double latitude;
  final double longitude;
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
