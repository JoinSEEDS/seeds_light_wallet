import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/providers.dart';
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
        Widget screen;
        Function onGenerateRoute;

        switch (auth.status) {
          case AuthStatus.INIT:
            screen = SplashScreen();
            break;
          case AuthStatus.CREATE:
            screen = Onboarding();
            break;
          case AuthStatus.LOCK:
            screen = LockWallet();
            break;
          case AuthStatus.UNLOCK:
            screen = UnlockWallet();
            break;
          case AuthStatus.OPEN:
            screen = App();
            break;
          default:
            screen = SplashScreen();
        }

        NavigationService navigationService = NavigationService.of(context);

        if (auth.status == AuthStatus.CREATE) {
          onGenerateRoute = navigationService.onGenerateRouteFromOnboarding;
        } else if (auth.status == AuthStatus.OPEN) {
          onGenerateRoute = navigationService.onGenerateRouteFromApplication;
        }

        return ToolboxApp(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigationService.navigatorKey,
            home: screen,
            onGenerateRoute: onGenerateRoute,
          ),
          noItemsFoundWidget: Padding(
            padding: const EdgeInsets.all(32),
            child: SvgPicture.asset(R.noItemFound),
          ),
        );
      },
    );
  }
}
