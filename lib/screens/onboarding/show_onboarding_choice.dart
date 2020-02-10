import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/widgets/main_button.dart';

class ShowOnboardingChoice extends StatelessWidget {
  final Function onInvite;
  final Function onImport;

  ShowOnboardingChoice({this.onInvite, this.onImport});

  Widget buildGroup(String text, String title, Function onPressed) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Icon(Icons.arrow_downward, color: AppColors.blue, size: 25),
        MainButton(
          margin: EdgeInsets.only(left: 33, right: 33, top: 10),
          title: title,
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget buildBottom() {
    final seedsUrl = 'joinseeds.com';

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'You can ask for invite at ',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
                TextSpan(
                  text: seedsUrl,
                  style: TextStyle(fontSize: 14, color: AppColors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => safeLaunch('https://www.$seedsUrl'),
                ),
                TextSpan(
                  text: '\n\nMembership based on Web of Trust',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildGroup(
          'If you have an account\nclick here',
          'Import private key',
          onImport,
        ),
        buildGroup(
          'If you have an invite\nclick here',
          'Claim invite code',
          onInvite,
        ),
        buildBottom()
      ],
    );
  }
}
