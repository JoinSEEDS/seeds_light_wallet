import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/biometrics/biometrics_verification.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';

import 'generated/r.dart';

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
