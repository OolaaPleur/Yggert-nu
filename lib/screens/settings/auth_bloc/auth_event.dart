part of 'auth_bloc.dart';

/// Defines events for [AuthBloc].
abstract class AuthEvent {}

/// Event which occurs when user presses sign in with Google button.
class SignInWithGoogleEvent extends AuthEvent {}
/// Event which occurs when user presses logout button.
class SignOutEvent extends AuthEvent {}
/// Event which occurs when user presses button, which uploads user settings.
class UploadUserSettingsEvent extends AuthEvent {}
/// Event which occurs when user presses button, which downloads
/// user settings.
class DownloadUserSettingsEvent extends AuthEvent {}
