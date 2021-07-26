import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/providers.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/main.dart';

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
        BlocProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc()..add(const InitAuthStatus())),
        BlocProvider<RatesBloc>(create: (_) => RatesBloc()),
        BlocProvider<DeeplinkBloc>(create: (_) => DeeplinkBloc()),
      ],
      child: MultiProvider(providers: providers, child: const MainScreen()),
    );
  }
}
