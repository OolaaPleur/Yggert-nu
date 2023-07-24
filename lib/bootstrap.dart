import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'utils/app_bloc_observer.dart';
import 'utils/firebase_options.dart';

/// Starts an observer and an app.
Future<void> bootstrap() async {
  /// Logger initialisation.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}');
  });

  /// Log errors.
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  /// Start BLoC observer.
  Bloc.observer = const AppBlocObserver();

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) => '';
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}
