import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/authentication/login_screen.dart';
import 'package:seeds/screens/authentication/sign_up/signup_screen.dart';
import 'package:seeds/screens/authentication/splash_screen.dart';
import 'package:seeds/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/screens/onboarding/onboarding_screen.dart';

class SeedsApp extends StatelessWidget {
  const SeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc()..add(const InitAuthStatus())),
        BlocProvider<RatesBloc>(create: (_) => RatesBloc()),
        BlocProvider<DeeplinkBloc>(create: (_) => DeeplinkBloc()),
      ],
      child: MultiProvider(
        providers: [Provider(create: (_) => NavigationService())],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
        ),
      ),
    );
  }
}

class SeedsMaterialApp extends MaterialApp {
  SeedsMaterialApp({Key? key, required home, navigatorKey, onGenerateRoute})
      : super(
          key: key,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('es', 'ES'),
            const Locale('pt', "BR"),
          ],
          //debugShowCheckedModeBanner: false,
          //debugShowMaterialGrid: true,
          home: I18n(child: home),
          theme: SeedsAppTheme.darkTheme,
          navigatorKey: navigatorKey,
          onGenerateRoute: onGenerateRoute,
        );
}
