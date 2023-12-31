
import 'package:flutter_test/flutter_test.dart';
import 'package:yggert_nu/data/models/estonia_public_transport.dart';
import 'package:yggert_nu/utils/gtfs_list_operations.dart';

void main() {
  group('GtfsListOperations', () {
    test('getDaysOfWeekString', () {
      // Arrange
      final calendarUtil = GtfsListOperations(); // replace with actual class instance creation
      final calendars = [
        Calendar(
          serviceId: 'service2',
          daysOfWeek: [false, true, false, true, false, true, false],
          startDate: DateTime(2023),
          endDate: DateTime(2023, 12, 31),
        ),
      ];

      // Act
      final daysOfWeekString = calendarUtil.getDaysOfWeekString(calendars);

      // Assert
      expect(daysOfWeekString, 'Tue, Thu, Sat');
    });
  });
}
