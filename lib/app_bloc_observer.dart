import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/map/bloc/map_bloc.dart';
import 'package:mobility_app/theme/bloc/theme_bloc.dart';

import 'main.dart';

/// Bloc state observer.
class AppBlocObserver extends BlocObserver {
  /// Constructor for Bloc observer.
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc.runtimeType == MapBloc) {
      // ignore: avoid_dynamic_calls
      log('onChange(${bloc.runtimeType}, ${change.currentState.status} - ${change.nextState.status})');
    } else {
      log('onChange(${bloc.runtimeType}, ${change.currentState} - ${change.nextState})');
    }
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

  runApp(BlocProvider(create: (context) => ThemeBloc()..loadTheme(), child: const MyApp()));
}
