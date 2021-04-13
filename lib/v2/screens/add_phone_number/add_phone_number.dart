import 'package:flutter/material.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';

/// Login SCREEN
class AddPhoneNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            const TextFormFieldCustom(labelText: "Add Phone Number"),
            Expanded(
                child: Text("Note: Your phone number is encrypted and never shared with anyone.",
                    style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)),
            FlatButtonLong(
              title: "Next",
              onPressed: () {},
            ),
            TextButton(onPressed: () {}, child: Text("Skip for now", style: Theme.of(context).textTheme.button))
          ]),
        ));
  }
}
