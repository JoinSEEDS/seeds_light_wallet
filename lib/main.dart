import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seeds/onboarding.dart';

import './app.dart';

Future<String> initializedAccountName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String accountName = prefs.getString("accountName");

  if (accountName != null && accountName != "") {
    return accountName;
  } else {
    return null;
  }
}

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
    return FutureBuilder(
      future: initializedAccountName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return App(snapshot.data);
        }
        return Onboarding();
      },
    );
  }
}