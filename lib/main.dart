import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:hive/hive.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/biometrics/biometrics_verification.dart';
import 'package:seeds/models/VoteResultAdapter.dart';
import 'package:seeds/models/member_adapter.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/models/transaction_adapter.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/providers/services/firebase/firebase_remote_config.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/providers/services/firebase/push_notification_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/ecosystem/tables_explorer/tables_explorer.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';
import 'package:sentry/sentry.dart' as Sentry;

import 'generated/r.dart';

final Sentry.SentryClient _sentry = Sentry.SentryClient(
    dsn: "https://ee2dd9f706974248b5b4a10850586d94@sentry.io/2239437");

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

  return TempApp();

  var appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter<MemberModel>(MemberAdapter());
  Hive.registerAdapter<VoteResult>(VoteResultAdapter());
  Hive.registerAdapter<TransactionModel>(TransactionAdapter());
  await Firebase.initializeApp();
  FirebaseRemoteConfigService().initialise();
  PushNotificationService().initialise();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    if (isInDebugMode) {
      runApp(SeedsApp());
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

      runZonedGuarded<Future<Null>>(() async {
        runApp(SeedsApp());
      }, (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
}

class SeedsMaterialApp extends MaterialApp {
  SeedsMaterialApp({home, navigatorKey, onGenerateRoute})
      : super(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', "US"),
              const Locale('es', "ES"),
            ],
            //debugShowCheckedModeBanner: false,
            //debugShowMaterialGrid: true,
            home: I18n(child: home),
            navigatorKey: navigatorKey,
            onGenerateRoute: onGenerateRoute);
}

class TempApp extends StatefulWidget {
  @override
  _TempAppState createState() => _TempAppState();
}

class _TempAppState extends State<TempApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TablesExplorer(),
      ),
    );
  }
}

class SeedsApp extends StatefulWidget {
  @override
  _SeedsAppState createState() => _SeedsAppState();
}

class _SeedsAppState extends State<SeedsApp> {
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

        if (auth.status == AuthStatus.emptyAccount ||
            auth.status == AuthStatus.recoveryMode) {
          return SeedsMaterialApp(
            home: auth.status == AuthStatus.emptyAccount
                ? Onboarding()
                : JoinProcess(),
            navigatorKey: navigationService.onboardingNavigatorKey,
            onGenerateRoute: navigationService.onGenerateRoute,
          );
        } else if (auth.status == AuthStatus.unlocked) {
          return ToolboxApp(
            child: SeedsMaterialApp(
              home: App(),
              navigatorKey: navigationService.appNavigatorKey,
              onGenerateRoute: navigationService.onGenerateRoute,
            ),
            noItemsFoundWidget: Padding(
              padding: const EdgeInsets.all(32),
              child: SvgPicture.asset(R.noItemFound),
            ),
          );
        } else if (auth.status == AuthStatus.emptyPasscode) {
          return SeedsMaterialApp(
            home: LockWallet(),
          );
        } else if (auth.status == AuthStatus.locked) {
          return SeedsMaterialApp(
            home: BiometricsVerification(),
          );
        } else {
          return SeedsMaterialApp(
            home: SplashScreen(),
          );
        }
      },
    );
  }
}
