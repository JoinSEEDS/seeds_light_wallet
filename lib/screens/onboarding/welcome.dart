import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';
import 'package:seeds/i18n/welcome.i18n.dart';

class Welcome extends StatelessWidget {
  final String accountName;

  Welcome(this.accountName);

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        OnboardingViewModel(
          bubble: Icons.done,
          mainImage: 'assets/images/onboarding/onboarding4.png',
          body: 'Your wallet almost ready - choose passcode to finish setup'.i18n,
          title: 'Welcome, %s'.i18n.fill(["$accountName"]),
        ),
      ],
      key: new UniqueKey(),
      onTapDoneButton: () async {
        AuthNotifier.of(context).resetPasscode();
      },
      doneButtonPersist: true,
      doneText: Text(
        "FINISH".i18n,
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
    );
  }
}
