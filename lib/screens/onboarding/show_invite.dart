import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';

class ShowInviteArguments {
  final String inviterAccount;
  final String inviteSecret;

  ShowInviteArguments(this.inviterAccount, this.inviteSecret);
}

class ShowInvite extends StatelessWidget {
  final String inviterAccountName;
  final String inviteSecret;

  ShowInvite(this.inviterAccountName, this.inviteSecret);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        [
          OnboardingViewModel(
            bubble: Icons.done,
            mainImage: 'assets/images/onboarding5.png',
            body: 'Accept your invite to create a new account and join SEEDS',
            title: 'You are invited by $inviterAccountName',
          ),
        ],
        key: new UniqueKey(),
        onTapDoneButton: () async {
          NavigationService.of(context).navigateTo("CreateAccoutn", inviteSecret, replace: true);
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
