import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/proposal_form.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/services/auth_service.dart';

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
    //return ProposalForm();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: authService.initializedAccount(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return App(snapshot.data);
          }
          return Onboarding();
        },
      ),
    );
  }
}
