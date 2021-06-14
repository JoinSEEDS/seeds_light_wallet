import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/recover_account_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/viewmodels/recover_account_events.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/viewmodels/recover_account_state.dart';
import 'package:seeds/v2/utils/debouncer.dart';

class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({Key? key}) : super(key: key);

  @override
  _RecoverAccountScreenState createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final TextEditingController _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RecoverAccountBloc(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormFieldCustom(
                    maxLength: 12,
                    counterText: null,
                    labelText: "Username",
                    controller: _keyController,
                    suffixIcon: QuadStateClipboardIconButton(
                      isChecked: state.isValidUsername,
                      onClear: () {
                        _keyController.clear();
                      },
                      isLoading: state.pageState == PageState.loading,
                      canClear: _keyController.text.isNotEmpty,
                    ),
                    onChanged: (String value) {
                      _debouncer.run(() {
                        BlocProvider.of<RecoverAccountBloc>(context).add(OnUsernameChanged(value));
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: state.errorMessage != null
                          ? Text(
                              state.errorMessage!,
                              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                            )
                          : const SizedBox.shrink()),
                  FlatButtonLong(
                    title: 'Next',
                    enabled: state.isValidUsername,
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
