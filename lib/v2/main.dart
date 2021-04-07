import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/features/biometrics/biometrics_verification.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/providers/services/firebase/push_notification_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/utils/old_toolbox/toolbox_app.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/domain-shared/bloc_observer.dart';
import 'package:seeds/v2/screens/login/login_screen.dart';
import 'package:seeds/v2/screens/onboarding/onboarding_screen.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to ?????
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  // TODO(gguij002): find better error reporting
  print('Caught error: $error');
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseRemoteConfigService().initialise();
  await settingsStorage.initialise();
  Bloc.observer = SimpleBlocObserver();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
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
              const Locale('en', 'US'),
              const Locale('es', 'ES'),
            ],
            //debugShowCheckedModeBanner: false,
            //debugShowMaterialGrid: true,
            home: I18n(child: home),
            theme: SeedsAppTheme.darkTheme,
            navigatorKey: navigatorKey,
            onGenerateRoute: onGenerateRoute);
}

class SeedsApp extends StatefulWidget {
  @override
  _SeedsAppState createState() => _SeedsAppState();
}

class _SeedsAppState extends State<SeedsApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatesBloc(),
      child: MultiProvider(
        providers: providers,
        child: const MainScreen(),
      ),
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
        var navigationService = NavigationService.of(context);
        PushNotificationService().initialise(context);

        if (auth.status == AuthStatus.emptyAccount || auth.status == AuthStatus.recoveryMode) {
          return SeedsMaterialApp(
            home: auth.status == AuthStatus.emptyAccount
                ? const OnboardingScreen()
                : SeedsMaterialApp(
                    home: LoginScreen(),
                  ),
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
