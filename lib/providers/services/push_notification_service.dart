import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  String token;

  Future initialise() async {
    if (!_initialized) {
      if (Platform.isIOS) {
        _firebaseMessaging.onIosSettingsRegistered.listen((data) {
          print("onIosSettingsRegistered data: $data");
        });

        _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
      }

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");

          final dynamic data = message['data'] ?? message;
          print("onResume: data");
          print("onResume: $data");
        },
      );

      // For testing purposes print the Firebase Messaging token
      token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _firebaseMessaging.onTokenRefresh.listen((event) {
        token = event;
      });

      _initialized = true;
    }
  }
}
