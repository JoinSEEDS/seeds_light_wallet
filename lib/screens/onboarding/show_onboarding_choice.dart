// @dart=2.9

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/utils/old_toolbox/toast.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seeds/i18n/show_onboarding_choice.i18n.dart';

class ShowOnboardingChoice extends StatelessWidget {
  final Function onInvite;
  final Function onImport;
  final Function onRecover;

  ShowOnboardingChoice({this.onInvite, this.onImport, this.onRecover});

  Widget buildGroup(String text, String title, Function onPressed) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Icon(Icons.arrow_downward, color: AppColors.blue, size: 25),
        MainButton(
          margin: EdgeInsets.only(left: 33, right: 33, top: 10),
          title: title,
          onPressed: onPressed,
          height: 40,
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
                  text: 'You can ask for an invite at'.i18n + ' ',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
                TextSpan(
                  text: seedsUrl,
                  style: TextStyle(fontSize: 14, color: AppColors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => safeLaunch(
                        'https://www.joinseeds.com/letmein?client=seedslight'),
                ),
                TextSpan(
                  text: '\n\n' +
                      "By signing up, you agree to our terms and privacy policy"
                          .i18n,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                color: Colors.transparent,
                child: Text(
                  'Terms & Conditions'.i18n,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 13,
                  ),
                ),
                onPressed: () =>
                    launch(remoteConfigurations.termsAndConditions),
              ),
              FlatButton(
                color: Colors.transparent,
                child: Text(
                  'Privacy Policy'.i18n,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 13,
                  ),
                ),
                onPressed: () => launch(remoteConfigurations.privacyPolicy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> safeLaunch(String urlString) async {
  if (await canLaunch(urlString)) {
    await launch(urlString);
  } else {
    errorToast("Couldn't open this url $urlString");
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 20,
          ),
          buildGroup(
            'If you have an account\nclick here'.i18n,
            'Import private key'.i18n,
            onImport,
          ),
          Container(
            height: 10,
          ),
          remoteConfigurations.featureFlagGuardiansEnabled
              ? buildGroup(
                  'If you forget your private key\nclick here'.i18n,
                  'Recover account'.i18n,
                  onRecover,
                )
              : SizedBox.shrink(),
          Container(
            height: 10,
          ),
          buildGroup(
            'If you have an invite\nclick here'.i18n,
            "Claim invite code".i18n,
            onInvite,
          ),
          Container(
            height: 10,
          ),
          // buildBottom()
        ],
      ),
    );
  }
}
