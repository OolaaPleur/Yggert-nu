/// Interface for scooters from all companies.
abstract class Scooter {
  /// Constructor for [Scooter].
  Scooter(this.id, this.charge, this.pricePerMinute, [this.companyName = '']);
  /// Scooter ID in 5-digit format (e.g. 12345 for Bolt or e.g.
  /// fb49g18h2dv48f32 for Tuul).
  final String id;
  /// Scooter current charge.
  final int charge;
  /// Holds price for fixed duration (e.g. 0.20€ for Tuul and 0.22/min for Bolt).
  final String pricePerMinute;
  /// Company, which owns scooter.
  final String companyName;
}
