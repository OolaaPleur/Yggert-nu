import 'package:yggert_nu/constants/constants.dart';

/// Functions, which converts String to City enum.
City? getMyEnumFromStr(String value) {
  for (final e in City.values) {
    if (e.toString() == 'City.$value') {
      return e;
    }
  }
  return null;
}
