// firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;  // ✅ Sekarang support web
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ✅ KONFIGURASI WEB (tambahkan)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDa8zq-XYNM60jj1loV4dtS8H808caJJgw',
    appId: '1:926441346584:web:b50fe35b1ae6e21446556d', 
    messagingSenderId: '926441346584',
    projectId: 'campus-task-manager',
    authDomain: 'campus-task-manager.firebaseapp.com', 
    storageBucket: 'campus-task-manager.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAOfkzD2Ceqbi7OEX4J9T7FNWH6IWEEjE',
    appId: '1:926441346584:android:739899f589fbe9e746556d',
    messagingSenderId: '926441346584',
    projectId: 'campus-task-manager',
    storageBucket: 'campus-task-manager.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAOfkzD2Ceqbi7OEX4J9T7FNWH6IWEEjE',
    appId: '1:926441346584:ios:739899f589fbe9e746556d',
    messagingSenderId: '926441346584',
    projectId: 'campus-task-manager',
    storageBucket: 'campus-task-manager.firebasestorage.app',
    iosBundleId: 'com.example.campustaskmanager',
  );
}