import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

const NUMBER_OF_WORDS = 12;
const NUMBER_OF_COLUMNS = 3;

class ImportWordsScreen extends StatelessWidget {
  const ImportWordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportKeyBloc(),
      child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
        builder: (context, state) {
          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButtonLong(
                title: 'Search'.i18n,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<ImportKeyBloc>(context).add(const FindAccountFromWords());
                },
                enabled: state.enableButton,
              ),
            ),
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Enter your 12-Word Recovery Phrase to recover your account.",
                        style: Theme.of(context).textTheme.subtitle3,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 24),
                      GridView.count(
                        padding: const EdgeInsets.only(top: 16),
                        // to disable GridView's scrolling
                        physics: const NeverScrollableScrollPhysics(),
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
                                  textInputAction: index < 11 ? TextInputAction.next : TextInputAction.done,
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
                                return wordList.where((String option) {
                                  return option.startsWith(textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (String selection) {
                                FocusScope.of(context).nextFocus();
                                BlocProvider.of<ImportKeyBloc>(context)
                                    .add(OnWordChange(word: selection, wordIndex: index));
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      if (state.userEnteredWords.isEmpty)
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.subtitle2,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Tap here ',
                                style: Theme.of(context).textTheme.subtitle2Green2,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                    NavigationService.of(context).navigateTo(Routes.importKey);
                                  },
                              ),
                              const TextSpan(text: ' if you want to import using your Private Key. '),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      const ImportKeyAccountsWidget(),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
