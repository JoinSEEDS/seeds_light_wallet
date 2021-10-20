import 'package:flutter/material.dart';
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
      child: Provider(
        create: (_) => NavigationService(),
        child: BlocListener<DeeplinkBloc, DeeplinkState>(
          listenWhen: (previous, current) => previous.inviteLinkData == null && current.inviteLinkData != null,
          listener: (context, _) => BlocProvider.of<AuthenticationBloc>(context).add(const OnInviteLinkRecived()),
          child: Builder(
            builder: (context) {
              final navigator = NavigationService.of(context);
              return MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en', 'US'),
                  const Locale('es', 'ES'),
                  const Locale('pt', 'BR'),
                ],
                theme: SeedsAppTheme.darkTheme,
                navigatorKey: navigator.appNavigatorKey,
                onGenerateRoute: navigator.onGenerateRoute,
                builder: (_, child) {
                  return I18n(
                    child: BlocListener<AuthenticationBloc, AuthenticationState>(
                      listenWhen: (previous, current) => previous.authStatus != current.authStatus,
                      listener: (_, state) {
                        switch (state.authStatus) {
                          case AuthStatus.emptyAccount:
                            navigator.pushAndRemoveAll(Routes.onboarding);
                            break;
                          case AuthStatus.inviteLink:
                            navigator.pushAndRemoveAll(Routes.signup);
                            break;
                          case AuthStatus.recoveryMode:
                            navigator.pushAndRemoveAll(Routes.login);
                            break;
                          case AuthStatus.emptyPasscode:
                          case AuthStatus.locked:
                            navigator.pushAndRemoveAll(Routes.verification);
                            break;
                          case AuthStatus.unlocked:
                            navigator.pushAndRemoveAll(Routes.app);
                            break;
                          default:
                            navigator.pushAndRemoveAll(Routes.splash);
                            break;
                        }
                      },
                      child: child,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
