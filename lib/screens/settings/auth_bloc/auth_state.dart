part of 'auth_bloc.dart';

/// Status of downloading or uploading.
enum Status {
  /// Initial status.
  initial,
  /// Uploading data.
  uploading,
  /// Success, uploading is completed.
  uploadSuccess,
  /// Downloading data.
  downloading,
  /// Success, downloading is completed.
  downloadSuccess,
}
/// State for [AuthBloc].
class AuthState extends Equatable {
/// Constructor for [AuthState].
  const AuthState({
    this.user,
    this.error = noException,
    this.settings,
    this.dataStatus = Status.initial,
    this.infoMessage = InfoMessage.defaultMessage,
  });
  /// Info, related to signed user.
  final User? user;
  /// Error, which (if) occurred.
  final AppException error;
  /// App settings modified by user.
  final Map<String, dynamic>? settings;
  /// Indicates status of data, uploading, downloading, loading or initial.
  final Status dataStatus;
  /// Message, need to display some states of flow of an app, as [error]
  /// printed to snackbar if necessary.
  final InfoMessage infoMessage;

  @override
  List<Object?> get props => [user, error, settings, dataStatus,infoMessage];

  /// The copyWith method is used to duplicate an existing object, updating
  /// only the required fields, keeping the rest of the fields as they were
  /// in the original object.
  AuthState copyWith({
    User? user,
    AppException? error,
    Map<String, dynamic>? settings,
    Status? dataStatus,
    InfoMessage? infoMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error ?? this.error,
      settings: settings ?? this.settings,
      dataStatus: dataStatus ?? this.dataStatus,
      infoMessage: infoMessage ?? this.infoMessage,
    );
  }
}
