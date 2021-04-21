import 'package:flutter/material.dart';
// import 'package:seeds/providers/services/navigation_service.dart';
// import 'package:seeds/i18n/show_invite.i18n.dart';
// import 'package:intro_views_flutter/intro_views_flutter.dart';

class ShowInviteArguments {
  final String inviterAccountName;
  final String inviteSecret;

  ShowInviteArguments(this.inviterAccountName, this.inviteSecret);
}

class ShowInvite extends StatelessWidget {
  final ShowInviteArguments arguments;

  const ShowInvite(this.arguments);

  @override
  Widget build(BuildContext context) {
    // final inviterAccountName = arguments.inviterAccountName;
    // final inviteSecret = arguments.inviteSecret;

    return const Text("Accept your invite to create a new account and join SEEDS'.i18n");
    // return Builder(
    //   builder: (context) => IntroViewsFlutter(
    //     [
    //       OnboardingViewModel(
    //         bubble: Icons.done,
    //         mainImage: 'assets/images/onboarding/onboarding5.png',
    //         body: 'Accept your invite to create a new account and join SEEDS'.i18n,
    //         title: 'You are invited by %s'.i18n.fill(["$inviterAccountName"]),
    //       ),
    //     ],
    //     key: new UniqueKey(),
    //     onTapDoneButton: () async {
    //       NavigationService.of(context).navigateTo(Routes.createAccount, inviteSecret, true);
    //     },
    //     doneButtonPersist: true,
    //     doneText: Text(
    //       "ACCEPT".i18n,
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontFamily: "worksans",
    //         fontSize: 24,
    //         fontWeight: FontWeight.w800,
    //       ),
    //     ),
    //     showNextButton: true,
    //     showBackButton: true,
    //     pageButtonTextStyles: TextStyle(
    //       fontFamily: "worksans",
    //       fontSize: 18.0,
    //       fontWeight: FontWeight.w700,
    //     ),
    //   ),
    // );
  }
}
