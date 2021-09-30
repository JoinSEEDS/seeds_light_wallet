import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/screens/authentication/import_key/interactor/import_key_bloc.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

import 'interactor/viewmodels/import_key_state.dart';

const NUMBER_OF_WORDS = 12;
const NUMBER_OF_COLUMNS = 3;

class ImportWordsScreen extends StatefulWidget {
  const ImportWordsScreen({Key? key}) : super(key: key);

  @override
  _ImportKeyScreenState createState() => _ImportKeyScreenState();
}

class _ImportKeyScreenState extends State<ImportWordsScreen> {
  late ImportKeyBloc _importKeyBloc;

  @override
  void initState() {
    super.initState();
    _importKeyBloc = ImportKeyBloc(BlocProvider.of<AuthenticationBloc>(context));
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
            body: Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter your 12-Word Recovery Phrase to recover your account.",
                    style: Theme.of(context).textTheme.subtitle3,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    child: GridView.count(
                      padding: const EdgeInsets.only(top: 16),
                      // to disable GridView's scrolling
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: NUMBER_OF_COLUMNS,
                      childAspectRatio: NUMBER_OF_COLUMNS / 2,
                      children: List.generate(NUMBER_OF_WORDS, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: (index % NUMBER_OF_COLUMNS == 0) ? 0 : 8,
                              right: ((index + 1) % NUMBER_OF_COLUMNS == 0) ? 0 : 8),
                          child: Autocomplete<String>(
                            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                                FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                autocorrect: false,
                                enableSuggestions: false,
                                enabled: true,
                                onChanged: (value) {
                                  BlocProvider.of<ImportKeyBloc>(context)
                                      .add(OnWordChange(word: value, wordIndex: index));
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: (index + 1).toString(),
                                  border: const OutlineInputBorder(),
                                ),
                              );
                            },
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<String>.empty();
                              }
                              return WORDLIST.where((String option) {
                                return option.startsWith(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              BlocProvider.of<ImportKeyBloc>(context)
                                  .add(OnWordChange(word: selection, wordIndex: index));
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(right: 24, left: 24),
                  //   child: Text(
                  //     "If you already have a Seeds account, please enter your private key and your account will be imported automatically."
                  //         .i18n,
                  //     style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  const Expanded(child: ImportKeyAccountsWidget()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSubmitted() {
    FocusScope.of(context).unfocus();
    _importKeyBloc.add(const FindAccountFromWords());
  }
}
