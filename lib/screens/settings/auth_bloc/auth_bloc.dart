import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mobility_app/exceptions/exceptions.dart';

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
  }
  final SignInWithGoogleUseCase _signInWithGoogle = GetIt.instance.get<SignInWithGoogleUseCase>();
  final SignOutUseCase _signOut = GetIt.instance.get<SignOutUseCase>();
  final UploadUserSettingsUseCase _uploadUserSettings =
      GetIt.instance.get<UploadUserSettingsUseCase>();
  final DownloadUserSettingsUseCase _downloadUserSettings =
      GetIt.instance.get<DownloadUserSettingsUseCase>();
  /// Instance of Logger, used to log events and errors in AuthBloc.
  final log = Logger('AuthBloc');

  Future<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    if (state.userCredential == null) {
      try {
        final userCredential = await _signInWithGoogle.call();
        emit(state.copyWith(userCredential: userCredential));
      } catch (e) {
        emit(state.copyWith(error: const SomeErrorOccurred()));
        emit(state.copyWith(error: const AppException()));
      }
    } else {
      emit(state.copyWith(isDownloading: false, error: const AppException()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _signOut.call();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(error: const SomeErrorOccurred()));
    }
  }

  Future<void> _onUploadUserSettings(UploadUserSettingsEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isUploading: true));

    try {
      await _uploadUserSettings.call();
    } catch (e) {
      emit(state.copyWith(error: const SomeErrorOccurred()));
    }
    emit(state.copyWith(isUploading: false));
  }

  Future<void> _onDownloadUserSettings(
    DownloadUserSettingsEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final settings = await _downloadUserSettings.call();
      emit(state.copyWith(settings: settings, isDownloading: true));
    } catch (e) {
      log.severe(e.toString());
      emit(state.copyWith(error: const SomeErrorOccurred(), isDownloading: false));
    }
  }
}
