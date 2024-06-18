import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ImportKeyScreen extends StatefulWidget {
  const ImportKeyScreen({super.key});

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
    _importKeyBloc = ImportKeyBloc();
    _keyController.text = '';
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    FocusScope.of(context).unfocus();
    if (_formImportKey.currentState!.validate()) {
      _importKeyBloc.add(FindAccountByKey(privateKey: _keyController.text, words: []));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _importKeyBloc,
      child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(context.loc.importKeyAppBarTitle)),
            body: SafeArea(
              minimum: const EdgeInsets.symmetric(vertical: 16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _formImportKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                          child: Column(
                            children: [
                              TextFormFieldCustom(
                                autofocus: true,
                                labelText: context.loc.importKeyPrivateKeyFieldPlaceholder,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.paste, color: AppColors.white),
                                  onPressed: () async {
                                    final clipboardData = await Clipboard.getData('text/plain');
                                    final clipboardText = clipboardData?.text ?? '';
                                    _keyController.text = clipboardText;
                                    // ignore: use_build_context_synchronously
                                    BlocProvider.of<ImportKeyBloc>(context)
                                        .add(OnPrivateKeyChange(privateKeyChanged: clipboardText));
                                    _onSubmitted();
                                  },
                                ),
                                onFieldSubmitted: (value) {
                                  BlocProvider.of<ImportKeyBloc>(context)
                                      .add(OnPrivateKeyChange(privateKeyChanged: value));
                                },
                                controller: _keyController,
                                onChanged: (value) {
                                  BlocProvider.of<ImportKeyBloc>(context)
                                      .add(OnPrivateKeyChange(privateKeyChanged: value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_keyController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.titleSmall,
                              children: <TextSpan>[
                                TextSpan(
                                    text: context.loc.importKeyImportUsingRecoveryPhraseActionLink,
                                    style: Theme.of(context).textTheme.subtitle2Green2,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pop();
                                        NavigationService.of(context).navigateTo(Routes.importWords);
                                      }),
                                const TextSpan(text: " "),
                                TextSpan(text: context.loc.importKeyImportUsingRecoveryPhraseDescription),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const ImportKeyAccountsWidget(),
                      const SizedBox(height: 50),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonLong(
                          title: context.loc.importKeySearchButtonTitle,
                          onPressed: () => _onSubmitted(),
                          enabled: state.enableButton),
                    ),
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
