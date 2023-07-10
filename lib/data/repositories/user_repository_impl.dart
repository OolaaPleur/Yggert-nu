import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:mobility_app/domain/device_settings.dart';

import '../../domain/user_repositories/user_repository.dart';
import '../../exceptions/exceptions.dart';

/// Implementation of UserRepository, here implemented all functions, related
/// to user account.
class UserRepositoryImplementation implements UserRepository {
  late GoogleSignInAccount? _googleUser;
  late GoogleSignInAuthentication? _googleAuth;
  late OAuthCredential? _credential;
  /// Instance of Logger, used to log events and errors in UserRepositoryImplementation.
  final log = Logger('UserRepositoryImplementation');

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      _googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      _googleAuth = await _googleUser?.authentication;

      try {
        // Create a new credential
        _credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth?.accessToken,
          idToken: _googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        if (_credential != null) {
          final userCredential = await FirebaseAuth.instance.signInWithCredential(_credential!);
          return userCredential;
        } else {
          throw const SomeErrorOccurred();
        }
      } catch (e) {
        log.severe(e.toString());
        rethrow;
      }
    } catch (e) {
      log.severe(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      log.severe('Error signing out: $e');
      return false;
    }
  }

  @override
  Future<void> uploadUserSettings() async {
    final db = FirebaseFirestore.instance;
    final deviceSettings = DeviceSettings();

    // get user settings
    final userSettings = <String, dynamic>{
      'userTripsFilterValue': await deviceSettings.getStringValue('userTripsFilterValue'),
      'pickedCity': await deviceSettings.getStringValue('pickedCity'),
      'language_code': await deviceSettings.getStringValue('language_code'),
      'isDark': await deviceSettings.getBoolValue('isDark')
    };

    // get the firebase user
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    await db
        .collection('users')
        .doc(uid)
        .set(userSettings)
        .then((value) => log.finer('User Settings Uploaded'))
        .catchError((dynamic error) => log.severe('Failed to upload user settings: $error'));
  }

  @override
  Future<Map<String, dynamic>> downloadUserSettings() async {
    final db = FirebaseFirestore.instance;

    // Get the Firebase user
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    // Fetch the user settings from Firestore
    final DocumentSnapshot docSnapshot = await db.collection('users').doc(uid).get();

    // If the document exists on the database
    if (docSnapshot.exists) {
      // Parse the document data
      final data = docSnapshot.data()! as Map<String, dynamic>;

      final deviceSettings = DeviceSettings();
      // Store data back to SharedPreferences
      await deviceSettings.setStringValue('userTripsFilterValue', data['userTripsFilterValue'] as String?);
      await deviceSettings.setStringValue('pickedCity', data['pickedCity'] as String?);
      await deviceSettings.setStringValue('language_code', data['language_code'] as String?);
      await deviceSettings.setBoolValue('isDark', value: data['isDark'] as bool?);

      log.finer('User settings downloaded');
      return data;
    } else {
      log.severe('No settings to download');
      return {};
    }
  }
}
