import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/main.dart';
import 'package:seeds/navigation/navigation_service.dart';

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
          ],
          //debugShowCheckedModeBanner: false,
          //debugShowMaterialGrid: true,
          home: I18n(child: home),
          theme: SeedsAppTheme.darkTheme,
          navigatorKey: navigatorKey,
          onGenerateRoute: onGenerateRoute,
        );
}

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
        child: const MainScreen(),
      ),
    );
  }
}
