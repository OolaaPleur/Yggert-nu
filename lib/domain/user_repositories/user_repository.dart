import 'package:firebase_auth/firebase_auth.dart';

/// [UserRepository] is interface for functions, related to user.
/// interaction with app.
abstract class UserRepository {
  /// Function responsible for signing in with Google account.
  Future<User> signInWithGoogle();
  /// Function, which responsible for logging Google user out.
  Future<void> signOut();
  /// Function, which responsible for uploading Google user data to Firestore
  /// cloud.
  Future<void> uploadUserSettings();
  /// Function, which responsible for loading Google user data from Firestore
  /// cloud.
  Future<Map<String, dynamic>> downloadUserSettings();
}
