// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_LCId-tlvEOhyuBJVp6QrbAMIEGYB6FE',
    appId: '1:498296336983:android:d39c9d0b7d58e6f9',
    messagingSenderId: '498296336983',
    projectId: 'till-khatam-36371',
    databaseURL: 'https://till-khatam-36371.firebaseio.com',
    storageBucket: 'till-khatam-36371.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjUrF-zthEJT0YXBS__KGoYgJnGhUnYt0',
    appId: '1:498296336983:ios:2465ec961fcab666b2e912',
    messagingSenderId: '498296336983',
    projectId: 'till-khatam-36371',
    databaseURL: 'https://till-khatam-36371.firebaseio.com',
    storageBucket: 'till-khatam-36371.appspot.com',
    androidClientId: '498296336983-53kn6r7k9b6b8flicm0av8a2pvgg8gpc.apps.googleusercontent.com',
    iosClientId: '498296336983-n9klv5skvsjsidod1nkie25tce2k2ksf.apps.googleusercontent.com',
    iosBundleId: 'com.lightgear.iquran',
  );
}
