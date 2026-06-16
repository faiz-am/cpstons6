// File generated based on Firebase project: sehatkita-a5b4e
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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

  // =========================================================
  // Web Configuration (dari Firebase JS SDK config)
  // =========================================================
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5vj01eWCfRDYmYfEP61eFWjf1XdlLE0E',
    appId: '1:875638165481:web:30239989cba7738b800578',
    messagingSenderId: '875638165481',
    projectId: 'sehatkita-a5b4e',
    authDomain: 'sehatkita-a5b4e.firebaseapp.com',
    storageBucket: 'sehatkita-a5b4e.firebasestorage.app',
    measurementId: 'G-64SNV84V8B',
  );

  // =========================================================
  // Android (tambahkan google-services.json lalu isi di sini)
  // =========================================================
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5vj01eWCfRDYmYfEP61eFWjf1XdlLE0E',
    appId: '1:875638165481:web:30239989cba7738b800578',
    messagingSenderId: '875638165481',
    projectId: 'sehatkita-a5b4e',
    storageBucket: 'sehatkita-a5b4e.firebasestorage.app',
  );

  // =========================================================
  // iOS (tambahkan GoogleService-Info.plist lalu isi di sini)
  // =========================================================
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5vj01eWCfRDYmYfEP61eFWjf1XdlLE0E',
    appId: '1:875638165481:web:30239989cba7738b800578',
    messagingSenderId: '875638165481',
    projectId: 'sehatkita-a5b4e',
    storageBucket: 'sehatkita-a5b4e.firebasestorage.app',
    iosBundleId: 'com.example.sehatApp',
  );

  // =========================================================
  // macOS
  // =========================================================
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5vj01eWCfRDYmYfEP61eFWjf1XdlLE0E',
    appId: '1:875638165481:web:30239989cba7738b800578',
    messagingSenderId: '875638165481',
    projectId: 'sehatkita-a5b4e',
    storageBucket: 'sehatkita-a5b4e.firebasestorage.app',
    iosBundleId: 'com.example.sehatApp',
  );

  // =========================================================
  // Windows
  // =========================================================
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5vj01eWCfRDYmYfEP61eFWjf1XdlLE0E',
    appId: '1:875638165481:web:30239989cba7738b800578',
    messagingSenderId: '875638165481',
    projectId: 'sehatkita-a5b4e',
    storageBucket: 'sehatkita-a5b4e.firebasestorage.app',
  );
}
