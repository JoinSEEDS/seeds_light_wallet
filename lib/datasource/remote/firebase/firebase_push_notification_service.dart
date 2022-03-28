import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/firebase_models/push_notification_data.dart';

/// This is the [BackgroundMessageHandler] that will be called when a notification is received, when the app is in
/// background or terminated state. This is a top level function, outside of any class, and will run outside of app's
/// context, we cannot do any UI implementing logic here. that is we cannot add new notification to the [NotificationRepository.notificationStream],
/// in this handler.
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("FirebaseMessaging Handling a background message");
  // TODO(raul): we could storing locally the notification at this point to show later
}

class PushNotificationService {
  factory PushNotificationService() => _instance;

  PushNotificationService._();

  static final PushNotificationService _instance = PushNotificationService._();

  late final FirebaseMessaging _firebaseMessaging;
  late BehaviorSubject<PushNotificationData> _streamController;
  bool _initialized = false;
  String? token;

  Stream<PushNotificationData> get notificationStream => _streamController.stream;
  StreamSink<PushNotificationData> get _mySteamInputSink => _streamController.sink;
  void dispose() => _streamController.close();

  Future initialise() async {
    if (!_initialized) {
      _streamController = BehaviorSubject<PushNotificationData>();

      _firebaseMessaging = FirebaseMessaging.instance;

      // If the application has been opened from a terminated state
      await _firebaseMessaging.getInitialMessage().then((message) {
        if (message != null) {
          print("FirebaseMessaging getInitialMessage: $message");
          _onNotificationRecived(PushNotificationData.fromJson(message.data));
        }
      });

      // When app is in Foreground.
      FirebaseMessaging.onMessage.listen((message) {
        print("FirebaseMessaging onMessage -> ${message.data}");
        _onNotificationRecived(PushNotificationData.fromJson(message.data), isAppInForeground: true);
      });

      // When user press the push notification and the app is in background (not terminated).
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('interacted message opened from background -> ${message.data}');
        _onNotificationRecived(PushNotificationData.fromJson(message.data));
      });

      // When app is in background or Terminated.
      // It must not be an anonymous function. It must be a top-level function
      // (e.g. not a class method which requires initialization).
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      await _firebaseMessaging.subscribeToTopic("PUSH_RC");
      await _firebaseMessaging.subscribeToTopic("test");

      // For testing purposes print the Firebase Messaging token.
      token = await _firebaseMessaging.getToken();
      print('FirebaseMessaging token: $token');

      _firebaseMessaging.onTokenRefresh.listen((newToken) => token = newToken);

      if (Platform.isIOS) {
        await requestingPermissionForIOS();
      }

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

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> _onNotificationRecived(PushNotificationData data, {bool isAppInForeground = false}) async {
    _mySteamInputSink.add(data);

    // If remote config changed, set them to stale. And fetch new config
    if (data.isRefreshConfig) {
      remoteConfigurations.refresh();
    } else if (data.notificationType != null) {
      switch (data.notificationType) {
        case NotificationTypes.paymentReceived:
          // if (isAppInForeground)
          // eventBus.fire(const ShowSnackBar('Nueva notificación'));
          break;
        case NotificationTypes.guardianInviteReceived:
          // TODO(gguij002): We will handle this later when we work on guardians
          //  Navigate to Guardians Screen
          //   await NavigationService.of(context).navigateTo(Routes.guardianTabs);
          break;
        default:
      }
    }
  }
}
