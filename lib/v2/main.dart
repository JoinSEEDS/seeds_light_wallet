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
import 'package:seeds/providers/providers.dart';
import 'package:seeds/utils/old_toolbox/toolbox_app.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/bloc_observer.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/app/app.dart';
import 'package:seeds/v2/screens/authentication/login_screen.dart';
import 'package:seeds/v2/screens/onboarding/onboarding_screen.dart';
import 'package:seeds/v2/screens/verification/verification_screen.dart';
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
  settingsStorage.initialise();
  await PushNotificationService().initialise();
  await remoteConfigurations.initialise();
  Bloc.observer = SimpleBlocObserver();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    if (isInDebugMode) {
      runApp(const SeedsApp());
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
            pair.last,
          );
        }).sendPort,
      );

      runZonedGuarded<Future<Null>>(() async {
        runApp(const SeedsApp());
      }, (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
}

class SeedsMaterialApp extends MaterialApp {
  SeedsMaterialApp({required home, navigatorKey, onGenerateRoute})
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

class SeedsApp extends StatelessWidget {
  const SeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc()..add(const InitAuthStatus()),
        ),
        BlocProvider<RatesBloc>(create: (BuildContext context) => RatesBloc()),
      ],
      child: MultiProvider(
        providers: providers,
        child: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        var navigationService = NavigationService.of(context);
        switch (state.authStatus) {
          case AuthStatus.emptyAccount:
          case AuthStatus.recoveryMode:
            return SeedsMaterialApp(
              home: state.authStatus == AuthStatus.emptyAccount
                  ? const OnboardingScreen()
                  : SeedsMaterialApp(
                      home: LoginScreen(),
                    ),
              navigatorKey: navigationService.onboardingNavigatorKey,
              onGenerateRoute: navigationService.onGenerateRoute,
            );
          case AuthStatus.emptyPasscode:
            return SeedsMaterialApp(home: const VerificationScreen());
          case AuthStatus.locked:
            return SeedsMaterialApp(home: const VerificationScreen());
          case AuthStatus.unlocked:
            return ToolboxApp(
              child: SeedsMaterialApp(
                navigatorKey: navigationService.appNavigatorKey,
                onGenerateRoute: navigationService.onGenerateRoute,
                home: const App(),
              ),
            );
          default:
            return SeedsMaterialApp(home: SplashScreen());
        }
      },
    );
  }
}
