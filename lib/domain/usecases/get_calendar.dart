import '../../data/models/estonia_public_transport.dart';
import '../../data/repositories/vehicle_repository.dart';
/// Use case, function is to parse calendar into list.
class GetCalendar {
/// Constructor for [GetCalendar].
  GetCalendar({required this.repository});
  /// Vehicle repository.
  final VehicleRepository repository;
  /// Call function for [GetCalendar] function.
  Future<List<Calendar>> call() => repository.getCalendar();
}
