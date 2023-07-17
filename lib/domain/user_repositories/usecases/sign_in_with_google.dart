import 'package:firebase_auth/firebase_auth.dart';

import '../user_repository.dart';
/// Use case for function, which responsible for logging Google user out.
class SignInWithGoogleUseCase {
  /// Constructor for [SignInWithGoogleUseCase].
  SignInWithGoogleUseCase(this.repository);
  /// [UserRepository] interface.
  final UserRepository repository;
  /// Call function for [SignInWithGoogleUseCase] function.
  Future<User> call() {
    return repository.signInWithGoogle();
  }
}
