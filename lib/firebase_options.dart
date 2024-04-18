// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBeA1_6cc005a3LMv3TRe1ep0bDuFCZltc',
    appId: '1:117639569085:web:97a8cf5ee0a2a67835a1d4',
    messagingSenderId: '117639569085',
    projectId: 'notes-042024',
    authDomain: 'notes-042024.firebaseapp.com',
    storageBucket: 'notes-042024.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaujKZQ1swDHSss0dKTzhz2Ym8v66bWqg',
    appId: '1:117639569085:android:318e134297babbe335a1d4',
    messagingSenderId: '117639569085',
    projectId: 'notes-042024',
    storageBucket: 'notes-042024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuKl6c4tGGhuQsymljRDDEayuxt_AMzJ8',
    appId: '1:117639569085:ios:b557d1f51426100235a1d4',
    messagingSenderId: '117639569085',
    projectId: 'notes-042024',
    storageBucket: 'notes-042024.appspot.com',
    androidClientId: '117639569085-bj82ln4lb0311rds6qg83ndljp7g784s.apps.googleusercontent.com',
    iosClientId: '117639569085-h87vqrmlqjchaeoe4jlcnu46h824kc4r.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuKl6c4tGGhuQsymljRDDEayuxt_AMzJ8',
    appId: '1:117639569085:ios:b557d1f51426100235a1d4',
    messagingSenderId: '117639569085',
    projectId: 'notes-042024',
    storageBucket: 'notes-042024.appspot.com',
    androidClientId: '117639569085-bj82ln4lb0311rds6qg83ndljp7g784s.apps.googleusercontent.com',
    iosClientId: '117639569085-h87vqrmlqjchaeoe4jlcnu46h824kc4r.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeA1_6cc005a3LMv3TRe1ep0bDuFCZltc',
    appId: '1:117639569085:web:6133a644678835dd35a1d4',
    messagingSenderId: '117639569085',
    projectId: 'notes-042024',
    authDomain: 'notes-042024.firebaseapp.com',
    storageBucket: 'notes-042024.appspot.com',
  );

}