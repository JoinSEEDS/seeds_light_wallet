import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';

const guardianInviteReceived = 'guardianInviteReceived';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;
  String token;

  Future initialise(BuildContext context) async {
    if (!_initialized) {
      // Requesting Permission
      await requestingPermissionForIOS();
      // If the application has been opened from a terminated state
      await FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
        if (message != null) {
          print("FirebaseMessaging getInitialMessage: ${message}");
        }
      });
      // When user press the push notification and the app is in background (not terminated).
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => onMessageOpenedApp(message, context));
      // When app is in background or Terminated.
      // It must not be an anonymous function. It must be a top-level function
      // (e.g. not a class method which requires initialization).
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
      // When app is in Foreground.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) => print(message));
      // For testing purposes print the Firebase Messaging token.
      token = await _firebaseMessaging.getToken();
      print('FirebaseMessaging token: $token');

      _firebaseMessaging.onTokenRefresh.listen((newToken) => token = newToken);

      _initialized = true;
    }
  }

  Future<void> requestingPermissionForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> onMessageOpenedApp(RemoteMessage message, BuildContext context) async {
    print("FirebaseMessaging onMessageOpenedApp");
    if (message.data.isNotEmpty) {
      // Handle data message
      final Map<dynamic, dynamic> data = message.data;
      var notificationTypeId = data['notification_type_id'];

      if (notificationTypeId == guardianInviteReceived) {
        // Navigate to Guardians Screen
        await NavigationService.of(context).navigateTo(Routes.guardianTabs);
      }
    }

    // Handle notification message. Not needed right now. But we will use this soon.
    // message.notification
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("FirebaseMessaging Handling a background message");
}
