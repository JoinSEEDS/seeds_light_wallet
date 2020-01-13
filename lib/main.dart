import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/eos_service.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/viewmodels/auth.dart';
import 'package:seeds/viewmodels/balance.dart';
import 'package:seeds/viewmodels/members.dart';
import 'package:seeds/viewmodels/transactions.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/splash_screen.dart';

import 'generated/r.dart';

main(List<String> args) async {
  await DotEnv().load('.env');

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
      providers: [
        Provider.value(value: HttpService()),
        ChangeNotifierProvider.value(value: AuthModel()),
        ProxyProvider<AuthModel, EosService>(
          create: (context) => EosService(),
          update: (context, auth, eos) => eos..initDependencies(auth),
        ),
        ChangeNotifierProxyProvider<HttpService, MembersModel>(
          create: (context) => MembersModel(),
          update: (context, http, members) => members..initDependencies(http),
        ),
        ChangeNotifierProxyProvider2<AuthModel, HttpService, TransactionsModel>(
          create: (context) => TransactionsModel(),
          update: (context, auth, http, transactions) => transactions..initDependencies(auth: auth, http: http)
        ),
        ChangeNotifierProxyProvider2<AuthModel, HttpService, BalanceModel>(
          create: (context) => BalanceModel(),
          update: (context, auth, http, balance) => balance..initDependencies(auth: auth, http: http)
        ),
      ],
      child: Consumer<AuthModel>(builder: (ctx, auth, _) {
        Widget screen;

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

        return ToolboxApp(child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: screen,
        ), noItemsFoundWidget: Padding(
          padding: const EdgeInsets.all(32),
          child: SvgPicture.asset(R.noItemFound),
         ),
        );
      }),
    );
  }
}
