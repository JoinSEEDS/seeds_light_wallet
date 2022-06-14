import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';

class CitizenshipUpgradeInProgressDialog extends StatelessWidget {
  const CitizenshipUpgradeInProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const Image(image: AssetImage("assets/images/profile/celebration_icon.png")),
      children: [
        Text('Upgrading account ...'.i18n, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 18.0),
        Center(child: Container(height: 130, child: const FullPageLoadingIndicator())),
        const SizedBox(height: 18.0),
        FlatButtonLong(enabled: false, title: 'Done'.i18n, onPressed: () {}),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
