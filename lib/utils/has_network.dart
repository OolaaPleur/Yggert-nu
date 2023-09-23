import 'dart:io';

import 'package:flutter/foundation.dart';

/// Function, to check if there is any internet connection.
Future<bool> hasNetwork() async {
  if (!kIsWeb) {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  return true;
}
