import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/member_adapter.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
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
  var appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter<MemberModel>(MemberAdapter());
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

      runZoned<Future<Null>>(() async {
        runApp(SeedsApp());
      }, onError: (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
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

        if (auth.status == AuthStatus.emptyAccount) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: JoinProcess(),
            navigatorKey: navigationService.onboardingNavigatorKey,
            onGenerateRoute: navigationService.onGenerateRoute,
          );
        } else if (auth.status == AuthStatus.unlocked) {
          return ToolboxApp(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
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
