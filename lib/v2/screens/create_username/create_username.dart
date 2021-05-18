import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/create_username/interactor/create_username_bloc.dart';
import 'package:seeds/v2/screens/create_username/interactor/viewmodels/create_username_events.dart';
import 'package:seeds/v2/screens/create_username/interactor/viewmodels/create_username_state.dart';

/// Create Username screen
class CreateUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreateUsernameBloc(),
      child: BlocBuilder<CreateUsernameBloc, CreateUsernameState>(
        builder: (BuildContext context, CreateUsernameState state) {
          print("State is valid : " +state.isValidUsername.toString());
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormFieldCustom(
                    maxLength: 12,
                    labelText: "Username".i18n,
                    suffixIcon: Icon(
                      Icons.check_circle_outline,
                      color: state.isValidUsername ? AppColors.red : null,
                    ),
                    onChanged: (String text) {
                      BlocProvider.of<CreateUsernameBloc>(context).add(OnUsernameChange(userName: text));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Note: Usernames must be 12 characters long. "
                      "\n\n Usernames can only contain characters a-z  (all lowercase), 1 - 5 (no 0’s), and no special characters or full stops. "
                      "\n\n **Reminder! Your account name cannot be changed or deleted and will be public for other users to see.**",
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
        },
      ),
    );
  }
}
