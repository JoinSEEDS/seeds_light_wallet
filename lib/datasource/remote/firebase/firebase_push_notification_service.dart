import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

const guardianInviteReceived = 'guardianInviteReceived';

class PushNotificationService {
  factory PushNotificationService() => _instance;

  PushNotificationService._();

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;
  String? token;

  Future initialise() async {
    if (!_initialized) {
      // Requesting Permission
      await requestingPermissionForIOS();
      // If the application has been opened from a terminated state
      await FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print("FirebaseMessaging getInitialMessage: $message");
        }
      });
      await _firebaseMessaging.subscribeToTopic("PUSH_RC");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("FirebaseMessaging onMessage -> ${message.data}");
        // If remote config changed, set them to stale. And fetch new config
        if (message.data.containsKey("CONFIG_STATE")) {
          remoteConfigurations.refresh();
        }
      });

      // When user press the push notification and the app is in background (not terminated).
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => onMessageOpenedApp(message));
      // When app is in background or Terminated.
      // It must not be an anonymous function. It must be a top-level function
      // (e.g. not a class method which requires initialization).
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      // For testing purposes print the Firebase Messaging token.
      token = await _firebaseMessaging.getToken();
      print('FirebaseMessaging token: $token');

      _firebaseMessaging.onTokenRefresh.listen((newToken) => token = newToken);

      _initialized = true;
    }
  }

  Future<void> requestingPermissionForIOS() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission();
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

  Future<void> onMessageOpenedApp(RemoteMessage message) async {
    print("FirebaseMessaging onMessageOpenedApp");
    // TODO(gguij002): We will handle this later when we work  on guardians
    if (message.data.isNotEmpty) {
      // Handle data message
      // final Map<dynamic, dynamic> data = message.data;
      // var notificationTypeId = data['notification_type_id'];

      // if (notificationTypeId == guardianInviteReceived) {
      //   // Navigate to Guardians Screen
      //   await NavigationService.of(context).navigateTo(Routes.guardianTabs);
      // }
    }

    // Handle notification message. Not needed right now. But we will use this soon.
    // message.notification
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("FirebaseMessaging Handling a background message");
}
