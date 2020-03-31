import 'package:flutter/material.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/widgets/main_button.dart';
import 'package:teloswallet/widgets/main_text_field.dart';

class ChangeEndpoint extends StatelessWidget {
  ChangeEndpoint({Key key}) : super(key: key);

  final TextEditingController endpointController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.gradient),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                SettingsNotifier.of(context).nodeEndpoint,
                style: TextStyle(
                  fontFamily: "worksans",
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
            child: MainTextField(
              labelText: "Custom Endpoint",
              hintText: 'Enter URL',
              controller: endpointController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
            child: MainButton(
              title: 'Save endpoint',
              onPressed: () {
                SettingsNotifier.of(context).saveEndpoint(endpointController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
