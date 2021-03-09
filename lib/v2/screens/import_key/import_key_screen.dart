import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/screens/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/v2/screens/import_key/interactor/import_key_bloc.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_events.dart';

class ImportKeyScreen extends StatefulWidget {
  const ImportKeyScreen({Key key}) : super(key: key);

  @override
  _ImportKeyScreenState createState() => _ImportKeyScreenState();
}

class _ImportKeyScreenState extends State<ImportKeyScreen> {
  ImportKeyBloc _importKeyBloc;
  final _keyController = TextEditingController();
  final _formImportKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _importKeyBloc = ImportKeyBloc(SettingsNotifier.of(context), AuthNotifier.of(context));
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _importKeyBloc,
      child: Scaffold(
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
                          _onSubmitted();
                        },
                      ),
                      controller: _keyController,
                      onFieldSubmitted: (_) => _onSubmitted(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Private Key cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Text(
                "If you already have a Seeds account-enter active private key and account will be imported automatically.",
                style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: ImportKeyAccountsWidget()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButtonLong(title: 'Search', onPressed: () => _onSubmitted()),
            )
          ],
        ),
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
    if (_formImportKey.currentState.validate()) {
      _importKeyBloc.add(FindAccountByKey(userKey: _keyController.text));
    }
  }
}
