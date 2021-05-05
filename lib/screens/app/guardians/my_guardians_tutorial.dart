import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';

Future<void> showFirstTimeUserDialog(BuildContext buildContext) async {
  return showDialog<void>(
    context: buildContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var tutorialState = TutorialState.first;
      var actionButtonText = "Next";

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FadeInImage.assetNetwork(placeholder: getImage(tutorialState), image: getImage(tutorialState)),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  child: getContentText(tutorialState),
                )
              ],
            ),
          ),
          actions: <Widget>[
            MainButton(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
              title: actionButtonText,
              onPressed: () {
                if (tutorialState == TutorialState.fourth) {
                  Navigator.pop(context);
                  SettingsNotifier.of(buildContext).saveGuardianTutorialShown(true);
                  NavigationService.of(context).navigateTo(Routes.selectGuardians);
                } else {
                  setState(() {
                    if (tutorialState == TutorialState.third) {
                      actionButtonText = "Select Guardians";
                    }
                    tutorialState = getNextState(tutorialState);
                  });
                }
              },
            ),
          ],
        );
      });
    },
  );
}

TutorialState getNextState(TutorialState tutorialState) {
  switch (tutorialState) {
    case TutorialState.first:
      return TutorialState.second;
    case TutorialState.second:
      return TutorialState.third;
    case TutorialState.third:
      return TutorialState.fourth;
    case TutorialState.fourth:
      return TutorialState.done;
    case TutorialState.done:
      return TutorialState.done;
  }
}

String getImage(TutorialState tutorialState) {
  switch (tutorialState) {
    case TutorialState.first:
      return 'assets/images/guardians/guardian_tutorial_1.png';
    case TutorialState.second:
      return 'assets/images/guardians/guardian_tutorial_2.png';
    case TutorialState.third:
      return 'assets/images/guardians/guardian_tutorial_3.png';
    case TutorialState.fourth:
      return 'assets/images/guardians/guardian_tutorial_4.png';
    case TutorialState.done:
      return 'assets/images/guardians/guardian_tutorial_4.png';
  }
}

Widget getContentText(TutorialState tutorialState) {
  switch (tutorialState) {
    case TutorialState.first:
      return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Welcome to the '),
            TextSpan(text: '\nKey Guardians ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'feature'),
          ],
        ),
      );
    case TutorialState.second:
      return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Here, you can invite 3 - 5 individuals to help you secure your SEEDS account.')
          ],
        ),
      );
    case TutorialState.third:
      return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'If you ever lose your phone, forget your password or keyphrase, your '),
            TextSpan(text: '\nKey Guardians ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'will help you recover your account.'),
          ],
        ),
      );
    case TutorialState.fourth:
      return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
                text:
                    'Make sure to choose your guardians carefully and give them a heads up. The safety of your account may depend on them in the future!'),
          ],
        ),
      );
    case TutorialState.done:
      return const SizedBox.shrink();
  }
}

enum TutorialState {
  first,
  second,
  third,
  fourth,
  done,
}
