import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/import_key/import_key.i18n.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/screens/authentication/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/import_key_bloc.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';

import 'interactor/viewmodels/import_key_state.dart';

class ImportKeyScreen extends StatefulWidget {
  const ImportKeyScreen({Key? key}) : super(key: key);

  @override
  _ImportKeyScreenState createState() => _ImportKeyScreenState();
}

class _ImportKeyScreenState extends State<ImportKeyScreen> {
  late ImportKeyBloc _importKeyBloc;
  final _keyController = TextEditingController();
  final _formImportKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _importKeyBloc = ImportKeyBloc(BlocProvider.of<AuthenticationBloc>(context));
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _importKeyBloc,
      child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
        builder: (context, ImportKeyState state) {
          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButtonLong(title: 'Search'.i18n, onPressed: () => _onSubmitted(), enabled: state.enableButton),
            ),
            appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formImportKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          autofocus: true,
                          labelText: 'Private Key'.i18n,
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.paste,
                              color: AppColors.white,
                            ),
                            onPressed: () async {
                              var clipboardData = await Clipboard.getData('text/plain');
                              var clipboardText = clipboardData?.text ?? '';
                              _keyController.text = clipboardText;
                              BlocProvider.of<ImportKeyBloc>(context)
                                  .add(OnPrivateKeyChange(privateKeyChanged: clipboardText));
                              _onSubmitted();
                            },
                          ),
                          onFieldSubmitted: (value) {
                            BlocProvider.of<ImportKeyBloc>(context).add(OnPrivateKeyChange(privateKeyChanged: value));
                          },
                          controller: _keyController,
                          onChanged: (value) {
                            BlocProvider.of<ImportKeyBloc>(context).add(OnPrivateKeyChange(privateKeyChanged: value));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: Text(
                    "If you already have a Seeds account-enter active private key and account will be imported automatically."
                        .i18n,
                    style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const Expanded(child: ImportKeyAccountsWidget()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    FocusScope.of(context).unfocus();
    if (_formImportKey.currentState!.validate()) {
      _importKeyBloc.add(FindAccountByKey(userKey: _keyController.text));
    }
  }
}
