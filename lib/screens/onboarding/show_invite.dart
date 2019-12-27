import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/helpers.dart';

class ShowInvite extends StatelessWidget {
  final String inviterAccountName;
  final String inviteSecret;

  ShowInvite(this.inviterAccountName, this.inviteSecret);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        [
          page(
            bubble: Icons.done,
            mainImage: 'assets/images/onboarding5.png',
            body: 'Accept your invite to create a new account and join SEEDS',
            title: 'You are invited by $inviterAccountName',
          ),
        ],
        key: new UniqueKey(),
        onTapDoneButton: () async {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CreateAccount(inviteSecret),
            ),
          );
        },
        doneButtonPersist: true,
        doneText: Text(
          "ACCEPT",
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
