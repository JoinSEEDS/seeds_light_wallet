import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/signup_bloc.dart';
import 'package:seeds/utils/string_extension.dart';

class CreateDisplayNameScreen extends StatefulWidget {
  const CreateDisplayNameScreen({Key? key}) : super(key: key);

  @override
  _CreateDisplayNameStateScreen createState() => _CreateDisplayNameStateScreen();
}

class _CreateDisplayNameStateScreen extends State<CreateDisplayNameScreen> {
  late SignupBloc _bloc;
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SignupBloc>(context);
    _keyController.text = _bloc.state.displayName ?? '';
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
        body: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
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
                    FlatButtonLong(onPressed: _onNextPressed(), title: 'Next'.i18n),
                  ],
                ),
              ),
            );
          },
        ),
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
    _bloc.add(const OnBackPressed());
    return Future.value(false);
  }
}
