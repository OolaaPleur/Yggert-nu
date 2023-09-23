import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yggert_nu/screens/map/bloc/map_bloc.dart';
import 'package:yggert_nu/screens/settings/auth_bloc/auth_bloc.dart';

/// Bloc state observer.
class AppBlocObserver extends BlocObserver {
  /// Constructor for Bloc observer.
  const AppBlocObserver();

  @override
  void onClose(BlocBase<dynamic> bloc) {
    log('onClose(${bloc.runtimeType})');
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc.runtimeType == MapBloc) {
      log('onChange(${bloc.runtimeType}, ${(change.currentState as MapState).status} - ${(change.nextState as MapState).status})');
    } else if (bloc.runtimeType == AuthBloc) {
      log('onChange(${bloc.runtimeType}, ${(change.currentState as AuthState).dataStatus} - ${(change.nextState as AuthState).dataStatus})');
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
