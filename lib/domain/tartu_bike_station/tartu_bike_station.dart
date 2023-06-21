class TartuBikeStations {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int totalLockedCycleCount;

  TartuBikeStations(
      {required this.id,
        required this.name,
        required this.latitude,
        required this.longitude,
        required this.totalLockedCycleCount});

  factory TartuBikeStations.fromJson(Map<String, dynamic> json) {
    return TartuBikeStations(
      id: json['id'],
      name: json['name'],
      latitude: json['areaCentroid']['latitude'],
      longitude: json['areaCentroid']['longitude'],
      totalLockedCycleCount: json['totalLockedCycleCount'],
    );
  }
}

class SingleBikeStation {
  final int bikeCount;
  final int pedelecCount;

  SingleBikeStation({required this.bikeCount, required this.pedelecCount});
}