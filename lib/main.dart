import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/http_service.dart';

import 'viewmodels/transactions.dart';

main(List<String> args) async {
  await DotEnv().load('.env');

  runApp(SeedsApp());
}

class SeedsApp extends StatefulWidget {
  @override
  _SeedsAppState createState() => _SeedsAppState();
}

class _SeedsAppState extends State<SeedsApp> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          Provider.value(value: HttpService()),
          Provider.value(value: AuthService()),
          ChangeNotifierProxyProvider2<AuthService, HttpService, TransactionsModel>(
            create: (context) => TransactionsModel(),
            update: (context, auth, http, model) => model..update(auth, http),
          )
        ],
        child: FutureBuilder(
          future: authService.initializedAccount(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return App(snapshot.data);
            }
            return Onboarding();
          },
        ),
      ),
    );
  }
}
