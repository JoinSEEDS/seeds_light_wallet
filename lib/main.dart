import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';

import 'generated/r.dart';

main(List<String> args) async {
  runApp(SeedsApp());
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
            home: Onboarding(),
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
