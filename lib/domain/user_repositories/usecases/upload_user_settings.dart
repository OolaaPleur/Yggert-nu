import '../user_repository.dart';
/// Use case for function, which responsible for loading Google user data
/// from Firestore cloud.
class UploadUserSettingsUseCase {
  /// Constructor for [UploadUserSettingsUseCase].
  UploadUserSettingsUseCase(this.repository);
  /// [UserRepository] interface.
  final UserRepository repository;
  /// Call function for [UploadUserSettingsUseCase] function.
  Future<void> call() {
    return repository.uploadUserSettings();
  }
}
