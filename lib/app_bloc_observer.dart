import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

/// Bloc state observer.
class AppBlocObserver extends BlocObserver {
  /// Constructor for Bloc observer.
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_dynamic_calls
    log('onChange(${bloc.runtimeType}, ${change.currentState.tripStatus} - ${change.nextState.tripStatus})');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Starts an observer and an app.
Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) => '';
  }

  runApp(const MyApp());
}
