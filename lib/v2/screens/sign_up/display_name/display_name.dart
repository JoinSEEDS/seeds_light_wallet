import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/i18n/sign_up/sign_up.i18n.dart';
import 'package:seeds/v2/utils/string_extension.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({Key? key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  late SignupBloc _bloc;
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SignupBloc>(context);
    _keyController.text = _bloc.state.displayNameState.displayName ?? '';
    _keyController.addListener(() {
      setState(() {
        // Do nothing
      });
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _navigateBack,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormFieldCustom(
                  labelText: 'Full Name'.i18n,
                  onFieldSubmitted: (_) => _onNextPressed(),
                  maxLength: 36,
                  controller: _keyController,
                  validator: (String? value) {
                    if (value.isNullOrEmpty) {
                      return 'Name cannot be empty'.i18n;
                    }
                    return null;
                  },
                ),
                Expanded(
                    child: Text(
                  "Enter your full name. You will be able to change this later in your profile settings.".i18n,
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                )),
                FlatButtonLong(
                  onPressed: _onNextPressed(),
                  title: 'Next'.i18n,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  VoidCallback? _onNextPressed() => _keyController.text.isNotEmpty
      ? () {
          FocusScope.of(context).unfocus();
          _bloc.add(DisplayNameOnNextTapped(_keyController.text));
        }
      : null;

  Future<bool> _navigateBack() {
    _bloc.add(OnBackPressed());
    return Future.value(false);
  }
}
