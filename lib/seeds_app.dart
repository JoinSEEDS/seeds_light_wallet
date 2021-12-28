import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/navigation/navigation_service.dart';

class SeedsApp extends StatelessWidget {
  const SeedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NavigationService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc()..add(const InitAuthStatus())),
          BlocProvider<RatesBloc>(create: (_) => RatesBloc()),
          BlocProvider<DeeplinkBloc>(create: (_) => DeeplinkBloc()),
        ],
        child: BlocListener<DeeplinkBloc, DeeplinkState>(
          listenWhen: (previous, current) => previous.inviteLinkData == null && current.inviteLinkData != null,
          listener: (context, _) => BlocProvider.of<AuthenticationBloc>(context).add(const OnInviteLinkRecived()),
          child: Builder(
            builder: (context) {
              final navigator = NavigationService.of(context);
              return MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
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
