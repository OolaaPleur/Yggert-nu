part of 'auth_bloc.dart';

/// Status of downloading or uploading.
enum Status {
  /// Initial status.
  initial,
  /// Loading status.
  loading,
  /// Success, loading is completed (or function completed without result).
  success
}
/// State for [AuthBloc].
class AuthState extends Equatable {
/// Constructor for [AuthState].
  const AuthState({
    this.user,
    this.error = noException,
    this.settings,
    this.uploadingStatus = Status.initial,
    this.downloadingStatus = Status.initial,
    this.infoMessage = InfoMessage.defaultMessage,
  });
  /// Info, related to signed user.
  final User? user;
  /// Error, which (if) occurred.
  final AppException error;
  /// App settings modified by user.
  final Map<String, dynamic>? settings;
  /// Indicates status, is data uploading or not.
  final Status downloadingStatus;
  /// Indicates status, is data downloading or not.
  final Status uploadingStatus;
  /// Message, need to display some states of flow of an app, as [error]
  /// printed to snackbar if necessary.
  final InfoMessage infoMessage;

  @override
  List<Object?> get props => [user, error, settings, uploadingStatus, downloadingStatus,infoMessage];

  /// The copyWith method is used to duplicate an existing object, updating
  /// only the required fields, keeping the rest of the fields as they were
  /// in the original object.
  AuthState copyWith({
    User? user,
    AppException? error,
    Map<String, dynamic>? settings,
    Status? downloadingStatus,
    Status? uploadingStatus,
    InfoMessage? infoMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error ?? this.error,
      settings: settings ?? this.settings,
      downloadingStatus: downloadingStatus ?? this.downloadingStatus,
      uploadingStatus: uploadingStatus ?? this.uploadingStatus,
      infoMessage: infoMessage ?? this.infoMessage,
    );
  }
}
