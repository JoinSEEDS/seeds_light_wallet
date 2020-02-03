import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/widgets/main_button.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MainButton(
        title: "Logout",
        onPressed: () {
          SettingsNotifier.of(context).removeAccount();
        },
      ),
    );
  }
}
