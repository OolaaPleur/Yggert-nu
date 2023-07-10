import '../user_repository.dart';
/// Use case for function, which responsible for loading Google user
/// data from Firestore cloud.
class DownloadUserSettingsUseCase {
  /// Constructor for [DownloadUserSettingsUseCase].
  DownloadUserSettingsUseCase(this.repository);
  /// [UserRepository] interface.
  final UserRepository repository;
  /// Call function for [DownloadUserSettingsUseCase] function.
  Future<Map<String, dynamic>> call() {
    return repository.downloadUserSettings();
  }
}
