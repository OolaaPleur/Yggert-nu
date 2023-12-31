// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members, public_member_api_docs, no_default_cases
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5_BMybALjC_FmV--P9QO-_u6Wtb-lgE0',
    appId: '1:751152486074:web:0ed0ffa7eedbb37dd6d483',
    messagingSenderId: '751152486074',
    projectId: 'yggert-nu',
    authDomain: 'yggert-nu.firebaseapp.com',
    storageBucket: 'yggert-nu.appspot.com',
    measurementId: 'G-6ZHVSYX4KV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLL9LqaLOYHNZRq4IpLyGcR0DJVLw25Eg',
    appId: '1:751152486074:android:44884bef878b7a19d6d483',
    messagingSenderId: '751152486074',
    projectId: 'yggert-nu',
    storageBucket: 'yggert-nu.appspot.com',
  );
}
