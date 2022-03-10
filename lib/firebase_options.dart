// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHtU_AxxhFlYiRA_J5n_-YgxVczHeoocw',
    appId: '1:757629481619:web:aca70a260046c765955366',
    messagingSenderId: '757629481619',
    projectId: 'flutter-notys',
    authDomain: 'flutter-notys.firebaseapp.com',
    storageBucket: 'flutter-notys.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8hRG0GJv2A6YWt2P233WxZc-und4iKOQ',
    appId: '1:757629481619:android:2051cd31a89b3df1955366',
    messagingSenderId: '757629481619',
    projectId: 'flutter-notys',
    storageBucket: 'flutter-notys.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAEPQSrbiySlUgEN8tJO9iA1oX_iYxpcY',
    appId: '1:757629481619:ios:dee6fa787d82999c955366',
    messagingSenderId: '757629481619',
    projectId: 'flutter-notys',
    storageBucket: 'flutter-notys.appspot.com',
    iosClientId: '757629481619-fusu20btib80dmuke74b6ang9d4a6lju.apps.googleusercontent.com',
    iosBundleId: 'quest.bkdev',
  );
}
