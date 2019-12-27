import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/screens/app/app.dart';

import 'helpers.dart';

class Welcome extends StatelessWidget {
  final String accountName;

  Welcome(this.accountName);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        [
          page(
            bubble: Icons.done,
            mainImage: 'assets/images/onboarding4.png',
            body: 'Your wallet almost ready - choose passcode to finish setup',
            title: 'Welcome, $accountName',
          ),
        ],
        key: new UniqueKey(),
        onTapDoneButton: () async {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => App(accountName),
            ),
          );
        },
        doneButtonPersist: true,
        doneText: Text(
          "FINISH",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "worksans",
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        showNextButton: true,
        showBackButton: true,
        pageButtonTextStyles: TextStyle(
          fontFamily: "worksans",
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}