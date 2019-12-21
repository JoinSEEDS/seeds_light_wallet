import 'package:flutter/material.dart';
import 'package:seeds/onboarding.dart';
import 'package:seeds/transferAmount.dart';
import 'package:seeds/transferForm.dart';

import './app.dart';

main(List<String> args) {
  runApp(SeedsApp());
}

class SeedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Onboarding(),
    );
  }
}