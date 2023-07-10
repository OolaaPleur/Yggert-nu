import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_app/screens/map/bloc/map_bloc.dart';
import 'package:mobility_app/screens/settings/auth_bloc/auth_bloc.dart';

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
    } else if (bloc.runtimeType == AuthBloc) {
      log('onChange(${bloc.runtimeType}');
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
