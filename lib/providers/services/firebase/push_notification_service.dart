import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';

const guardianInviteReceived = "guardianInviteReceived";

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  String token;

  Future initialise(BuildContext context) async {
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
          backgroundMessageHandler(message, context);
        },
      );

      // For testing purposes print the Firebase Messaging token
      token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        token = newToken;
      });

      _initialized = true;
    }
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message, BuildContext context) async {
  print("backgroundMessageHandler");
  if (message.containsKey('data')) {
    // Handle data message
    final Map<dynamic, dynamic> data = message['data'];
    print("onResume: data");
    print("onResume: $data");

    var notificationTypeId = data["notification_type_id"];
    print("onResume notificationTypeId: $notificationTypeId");

    if (notificationTypeId == guardianInviteReceived) {
      //Navigate to Guardians Screen
      NavigationService.of(context).navigateTo(Routes.guardianTabs);
    }
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("onResume: notification");
    print("onResume: $notification");
  }

  print("onResume: Do other work");
}
