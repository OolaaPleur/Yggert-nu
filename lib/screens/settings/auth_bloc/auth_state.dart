part of 'auth_bloc.dart';

/// State for [AuthBloc].
class AuthState extends Equatable {
/// Constructor for [AuthState].
  const AuthState({
    this.userCredential,
    this.error = noException,
    this.settings,
    this.isUploading = false,
    this.isDownloading = false,
  });
  /// Info, related to signed user.
  final UserCredential? userCredential;
  /// Error, which (if) occurred.
  final AppException error;
  /// App settings modified by user.
  final Map<String, dynamic>? settings;
  /// Indicates status, is data uploading or not.
  final bool isUploading;
  /// Indicates status, is data downloading or not.
  final bool isDownloading;

  @override
  List<Object?> get props => [userCredential, error, settings, isUploading, isDownloading,];

  /// The copyWith method is used to duplicate an existing object, updating
  /// only the required fields, keeping the rest of the fields as they were
  /// in the original object.
  AuthState copyWith({
    UserCredential? userCredential,
    AppException? error,
    Map<String, dynamic>? settings,
    bool? isUploading,
    bool? isDownloading,
  }) {
    return AuthState(
      userCredential: userCredential ?? this.userCredential,
      error: error ?? this.error,
      settings: settings ?? this.settings,
      isUploading: isUploading ?? this.isUploading,
      isDownloading: isDownloading ?? this.isDownloading,
    );
  }
}
