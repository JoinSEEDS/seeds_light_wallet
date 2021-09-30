import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_words/interactor/import_words_bloc.dart';
import 'package:seeds/screens/authentication/import_words/interactor/viewmodels/import_words_events.dart';
import 'package:seeds/screens/authentication/import_words/interactor/viewmodels/import_words_state.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

const NUMBER_OF_WORDS = 12;
const NUMBER_OF_COLUMNS = 3;

class ImportWordsScreen extends StatefulWidget {
  const ImportWordsScreen({Key? key}) : super(key: key);

  @override
  _ImportWordsScreenState createState() => _ImportWordsScreenState();
}

class _ImportWordsScreenState extends State<ImportWordsScreen> {
  late ImportWordsBloc _importWordsBloc;

  @override
  void initState() {
    super.initState();
    _importWordsBloc = ImportWordsBloc(BlocProvider.of<AuthenticationBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _importWordsBloc,
      child: BlocBuilder<ImportWordsBloc, ImportWordsState>(
        builder: (context, ImportWordsState state) {
          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButtonLong(title: 'Search'.i18n, onPressed: () => _onSubmitted(), enabled: state.enableButton),
            ),
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Column(
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
                                  BlocProvider.of<ImportWordsBloc>(context)
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
                              BlocProvider.of<ImportWordsBloc>(context)
                                  .add(OnWordChange(word: selection, wordIndex: index));
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  // const SizedBox(height: 24),
                  // const Expanded(child: ImportKeyAccountsWidget()),
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
    _importWordsBloc.add(const FindAccountFromWords());
  }
}
