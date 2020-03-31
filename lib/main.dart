import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/models/models.dart';
import 'package:teloswallet/models/transaction_adapter.dart';
import 'package:teloswallet/providers/notifiers/auth_notifier.dart';
import 'package:teloswallet/providers/providers.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';
import 'package:teloswallet/screens/app/app.dart';
import 'package:teloswallet/screens/onboarding/onboarding.dart';
import 'package:teloswallet/widgets/passcode.dart';
import 'package:teloswallet/widgets/splash_screen.dart';
import 'package:sentry/sentry.dart' as Sentry;

final Sentry.SentryClient _sentry = Sentry.SentryClient(
    dsn: "https://0d8efb4e01384655ad21e58ca64d86a0@sentry.io/5181804");

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  print('Reporting to Sentry.io...');

  final Sentry.SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter<TransactionModel>(TransactionAdapter());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    if (isInDebugMode) {
      runApp(TelosApp());
    } else {
      FlutterError.onError = (FlutterErrorDetails details) async {
        print('FlutterError.onError caught an error');
        await _reportError(details.exception, details.stack);
      };

      Isolate.current.addErrorListener(
        RawReceivePort((dynamic pair) async {
          print('Isolate.current.addErrorListener caught an error');
          await _reportError(
            (pair as List<String>).first,
            (pair as List<String>).last,
          );
        }).sendPort,
      );

      runZoned<Future<Null>>(() async {
        runApp(TelosApp());
      }, onError: (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
}

class TelosApp extends StatefulWidget {
  @override
  _TelosAppState createState() => _TelosAppState();
}

class _TelosAppState extends State<TelosApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (ctx, auth, _) {
        NavigationService navigationService = NavigationService.of(context);

        if (auth.status == AuthStatus.emptyAccount) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Onboarding(),
            navigatorKey: navigationService.onboardingNavigatorKey,
            onGenerateRoute: navigationService.onGenerateRoute,
          );
        } else if (auth.status == AuthStatus.unlocked) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: App(),
            navigatorKey: navigationService.appNavigatorKey,
            onGenerateRoute: navigationService.onGenerateRoute,
          );
        } else if (auth.status == AuthStatus.emptyPasscode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LockWallet(),
          );
        } else if (auth.status == AuthStatus.locked) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: UnlockWallet(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }
      },
    );
  }
}
