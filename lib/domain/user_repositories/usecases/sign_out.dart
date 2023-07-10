import '../user_repository.dart';
/// Use case for function, which responsible for logging Google user out.
class SignOutUseCase {
  /// Constructor for [SignOutUseCase].
  SignOutUseCase(this.repository);
  /// [UserRepository] interface.
  final UserRepository repository;
  /// Call function for [SignOutUseCase] function.
  Future<void> call() {
    return repository.signOut();
  }
}
