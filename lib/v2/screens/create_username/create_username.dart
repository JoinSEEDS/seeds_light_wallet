import 'package:flutter/material.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/design/app_theme.dart';

/// Create Username screen
class CreateUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool var_name = false;
    int count = 0;
    int maxCount = 12;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormFieldCustom(
                labelText: "Username".i18n,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: var_name == false ? null : Colors.green,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "$count",
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                ),
                Text(
                  "/",
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                ),
                Text(
                  "$maxCount",
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Note: Usernames must be 12 characters long.",
              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Usernames can only contain characters a-z  (all lowercase), 1 - 5 (no 0’s), and no special characters or full stops.",
              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Text(
                "**Reminder! Your account name cannot be changed or deleted and will be public for other users to see.**",
                style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
              ),
            ),
            FlatButtonLong(
              title: 'Next'.i18n,
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
