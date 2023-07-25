/// Interface for cars from all companies.
abstract class Car {
  /// Constructor for [Car].
  Car(this.id, [this.companyName = '']);
  /// Car ID.
  final String id;
  /// Company, which owns car.
  final String companyName;
}
