import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';
import 'package:seeds/utils/debouncer.dart';

class CreateAccountNameScreen extends StatefulWidget {
  const CreateAccountNameScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountNameStateScreen createState() => _CreateAccountNameStateScreen();
}

class _CreateAccountNameStateScreen extends State<CreateAccountNameScreen> {
  late SignupBloc _signupBloc;
  final TextEditingController _keyController = TextEditingController();
  final _usernameFormKey = GlobalKey<FormState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    if (_signupBloc.state.accountName != null) {
      _keyController.text = _signupBloc.state.accountName!;
    } else {
      _signupBloc.add(OnGenerateNewUsername(_signupBloc.state.displayName!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _navigateBack,
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.pageState == PageState.initial && state.pageCommand is OnAccountNameGenerated) {
            _keyController.text = state.accountName ?? _keyController.text;
            _signupBloc.add(OnAccountNameChanged(state.accountName!));
          }

          if (state.pageState == PageState.failure) {
            SnackBarInfo(state.errorMessage ?? 'Oops, something went wrong. Please try again later.'.i18n,
                    ScaffoldMessenger.of(context))
                .show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            // From invite link, there isn't a screen below the stack thus no implicit back arrow
            appBar: AppBar(leading: state.fromDeepLink ? BackButton(onPressed: _navigateBack) : null),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                          key: _usernameFormKey,
                          child: TextFormFieldCustom(
                            maxLength: 12,
                            labelText: "Username".i18n,
                            controller: _keyController,
                            errorText: state.errorMessage,
                            suffixIcon: QuadStateClipboardIconButton(
                              isChecked: state.isUsernameValid,
                              onClear: () => _keyController.clear(),
                              isLoading: state.pageState == PageState.loading,
                              canClear: _keyController.text.isNotEmpty,
                            ),
                            onChanged: (text) {
                              _debouncer.run(() => _signupBloc.add(OnAccountNameChanged(text)));
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            "Note: Usernames must be 12 characters long.\n\n Usernames can only contain characters a-z (all lowercase), 1 - 5 (no 0’s), and no special characters or full stops. \n\n **Reminder! Your account name cannot be changed or deleted and will be public for other users to see.**"
                                .i18n,
                            style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                          ),
                        ),
                        FlatButtonLong(
                          title: 'Create account'.i18n,
                          onPressed: state.isNextButtonActive
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  _signupBloc.add(OnCreateAccountTapped(_keyController.text));
                                }
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  if (state.pageState == PageState.loading) const FullPageLoadingIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _navigateBack() {
    _signupBloc.add(const OnBackPressed());
    return Future.value(false);
  }
}
