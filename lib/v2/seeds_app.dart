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
import 'package:seeds/v2/main.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/app/app.dart';
import 'package:seeds/v2/screens/authentication/login_screen.dart';
import 'package:seeds/v2/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/v2/screens/onboarding/onboarding_screen.dart';
import 'package:seeds/widgets/splash_screen.dart';

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
          create: (BuildContext context) =>
              AuthenticationBloc()..add(const InitAuthStatus()),
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
