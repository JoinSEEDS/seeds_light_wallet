import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/v2/datasource/local/member_model_cache_item.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/vote_model.dart';
import 'package:seeds/v2/domain-shared/bloc_observer.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/app/app.dart';
import 'package:seeds/v2/screens/authentication/login_screen.dart';
import 'package:seeds/v2/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/v2/screens/onboarding/onboarding_screen.dart';
import 'package:seeds/v2/screens/sign_up/signup_screen.dart';
import 'package:seeds/v2/seeds_material_app.dart';
import 'package:seeds/widgets/splash_screen.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to ?????
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // TODO(gguij002): find better error reporting
  print('Caught error: $error');
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await settingsStorage.initialise();
  await PushNotificationService().initialise();
  await remoteConfigurations.initialise();
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(MemberModelCacheItemAdapter());
  Hive.registerAdapter(VoteModelAdapter());

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

      runZonedGuarded<Future<void>>(() async {
        runApp(const SeedsApp());
      }, (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final navigationService = NavigationService.of(context);
        switch (state.authStatus) {
          case AuthStatus.emptyAccount:
          case AuthStatus.recoveryMode:
            return BlocBuilder<DeeplinkBloc, DeeplinkState>(
              builder: (context, deepLinkState) {
                if (deepLinkState.inviteLinkData != null) {
                  return SeedsMaterialApp(
                    home: SignupScreen(deepLinkState.inviteLinkData!.mnemonic),
                  );
                } else {
                  return SeedsMaterialApp(
                    home: state.authStatus == AuthStatus.emptyAccount
                        ? const OnboardingScreen()
                        : SeedsMaterialApp(
                            home: const LoginScreen(),
                          ),
                    navigatorKey: navigationService.onboardingNavigatorKey,
                    onGenerateRoute: navigationService.onGenerateRoute,
                  );
                }
              },
            );
          case AuthStatus.emptyPasscode:
            return SeedsMaterialApp(home: const VerificationScreen());
          case AuthStatus.locked:
            return SeedsMaterialApp(home: const VerificationScreen());
          case AuthStatus.unlocked:
            return SeedsMaterialApp(
              navigatorKey: navigationService.appNavigatorKey,
              onGenerateRoute: navigationService.onGenerateRoute,
              home: const App(),
            );
          default:
            return SeedsMaterialApp(home: const SplashScreen());
        }
      },
    );
  }
}
