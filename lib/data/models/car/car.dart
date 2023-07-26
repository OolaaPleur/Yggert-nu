/// Interface for cars from all companies.
abstract class Car {
  /// Constructor for [Car].
  Car(this.id, this.pricePerMinute, [this.companyName = '']);
  /// Car ID.
  final String id;
  /// Company, which owns car.
  final String companyName;
  /// Price per minute.
  final String pricePerMinute;
}
