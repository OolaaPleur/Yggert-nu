import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:yggert_nu/exceptions/exceptions.dart';

import '../../../constants/constants.dart';
import '../../../domain/user_repositories/usecases/download_user_settings.dart';
import '../../../domain/user_repositories/usecases/sign_in_with_google.dart';
import '../../../domain/user_repositories/usecases/sign_out.dart';
import '../../../domain/user_repositories/usecases/upload_user_settings.dart';

part 'auth_event.dart';

part 'auth_state.dart';

/// BLoC for operations, related to user, signing in, logging out, uploading
/// or downloading user-related data.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Constructor for [AuthBloc].
  AuthBloc() : super(const AuthState()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<UploadUserSettingsEvent>(_onUploadUserSettings);
    on<DownloadUserSettingsEvent>(_onDownloadUserSettings);
    on<AutoSignIn>(_onAutoSignIn);
  }

  final SignInWithGoogleUseCase _signInWithGoogle = GetIt.instance.get<SignInWithGoogleUseCase>();
  final SignOutUseCase _signOut = GetIt.instance.get<SignOutUseCase>();
  final UploadUserSettingsUseCase _uploadUserSettings =
      GetIt.instance.get<UploadUserSettingsUseCase>();
  final DownloadUserSettingsUseCase _downloadUserSettings =
      GetIt.instance.get<DownloadUserSettingsUseCase>();

  /// Instance of Logger, used to log events and errors in AuthBloc.
  final log = Logger('AuthBloc');

  Future<void> _onAutoSignIn(AutoSignIn event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(state.copyWith(user: user));
      add(SignInWithGoogleEvent());
    }
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await _signInWithGoogle.call();
      emit(state.copyWith(user: user));
    } catch (e) {
      if (e.runtimeType == PlatformException) {
        emit(state.copyWith(error: const NoInternetConnectionInSettings()));
      } else {
        emit(state.copyWith(error: const SomeErrorOccurred()));
      }
      log.severe(e);
    }
    emit(state.copyWith(error: const AppException()));
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _signOut.call();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(error: const SomeErrorOccurred()));
    }
    emit(state.copyWith(error: const AppException()));
  }

  Future<void> _onUploadUserSettings(UploadUserSettingsEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(dataStatus: Status.uploading));
      await _uploadUserSettings.call();
      emit(state.copyWith(infoMessage: InfoMessage.userDataUploadedSuccessfully));
    } catch (e) {
      log.severe(e.toString());
      if (e.runtimeType == NoInternetConnectionInSettings) {
        emit(state.copyWith(error: const NoInternetConnectionInSettings()));
      } else {
        emit(state.copyWith(error: const SomeErrorOccurred()));
      }
    }
    emit(
      state.copyWith(
        error: const AppException(),
        dataStatus: Status.uploadSuccess,
        infoMessage: InfoMessage.defaultMessage,
      ),
    );
  }

  Future<void> _onDownloadUserSettings(
    DownloadUserSettingsEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(dataStatus: Status.downloading));
      final settings = await _downloadUserSettings.call();
      emit(
        state.copyWith(
          settings: settings,
          infoMessage: InfoMessage.userDataDownloadedSuccessfully,
        ),
      );
    } catch (e) {
      log.severe(e.toString());
      if (e.runtimeType == NoInternetConnectionInSettings) {
        emit(state.copyWith(error: const NoInternetConnectionInSettings()));
      } else {
        emit(state.copyWith(error: const SomeErrorOccurred()));
      }
    }
    emit(
      state.copyWith(
        error: const AppException(),
        dataStatus: Status.downloadSuccess,
        infoMessage: InfoMessage.defaultMessage,
      ),
    );
  }
}
