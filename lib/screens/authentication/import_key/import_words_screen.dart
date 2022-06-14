import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/import_key/components/import_words_accounts_widget.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

const _numberOfWords = 12;
const _numberOfColumns = 3;

class ImportWordsScreen extends StatelessWidget {
  const ImportWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImportKeyBloc(),
      child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
              child: FlatButtonLong(
                title: context.loc.importKeySearchButtonTitle,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<ImportKeyBloc>(context).add(const FindAccountFromWords());
                },
                enabled: state.enableButton,
              ),
            ),
            appBar: AppBar(title: Text(context.loc.importWordAppBarTitle)),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.loc.importWordUsingRecoveryPhraseTitle,
                        style: Theme.of(context).textTheme.subtitle3,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 24),
                      GridView.count(
                        padding: const EdgeInsets.only(top: 16),
                        // to disable GridView's scrolling
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: _numberOfColumns,
                        childAspectRatio: _numberOfColumns / 2,
                        children: List.generate(_numberOfWords, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: (index % _numberOfColumns == 0) ? 0 : 8,
                                right: ((index + 1) % _numberOfColumns == 0) ? 0 : 8),
                            child: Autocomplete<String>(
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                textEditingController.text = state.userEnteredWords[index] ?? "";
                                textEditingController.selection =
                                    TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
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
                      if (state.pageState != PageState.loading && state.accounts.isEmpty)
                        TextButton(
                          child: Text(context.loc.importWordClipBoardTitle),
                          onPressed: () {
                            BlocProvider.of<ImportKeyBloc>(context).add(const OnUserPastedWords());
                          },
                        ),
                      const SizedBox(height: 16),
                      if (state.userEnteredWords.isEmpty)
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.subtitle2,
                            children: <TextSpan>[
                              TextSpan(
                                text: context.loc.importKeyImportUsingPrivateKeyActionLink,
                                style: Theme.of(context).textTheme.subtitle2Green2,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                    NavigationService.of(context).navigateTo(Routes.importKey);
                                  },
                              ),
                              const TextSpan(text: " "),
                              TextSpan(text: context.loc.importKeyImportUsingPrivateKeyDescription),
                            ],
                          ),
                        ),
                      const ImportWordsAccountsWidget(),
                      const SizedBox(height: 36),
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
