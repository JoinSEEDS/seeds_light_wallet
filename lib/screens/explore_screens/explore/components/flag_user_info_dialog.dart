import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';

class FlagUserInfoDialog extends StatelessWidget {
  const FlagUserInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset("assets/images/profile/logout_icon.svg"),
      children: [
        Text('Flagging a Member'.i18n, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Text(
                'Flagging someone means they have done something to break the web of Trust in the Seeds Ecosystem. Fake accounts, fraud, cheating, hacking are some of the reasons that warrant flagging.'
                    .i18n,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              Text(
                'Whens someone has been flagged, their reputation points will go down; enough flags and their points will go down to zero. Flagging also affects all the subsequent members that have been vouched by the flagged member so be careful who you flag!'
                    .i18n,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              FlatButtonLong(
                title: 'Ok, Thank you.'.i18n,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ],
    );
  }
}
