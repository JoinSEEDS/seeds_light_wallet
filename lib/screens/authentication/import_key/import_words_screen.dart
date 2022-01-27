import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/import_key/components/import_key_accounts_widget.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

const NUMBER_OF_WORDS = 12;
const NUMBER_OF_COLUMNS = 3;

class ImportWordsScreen extends StatefulWidget {
  const ImportWordsScreen({Key? key}) : super(key: key);

  @override
  State<ImportWordsScreen> createState() => _ImportWordsScreenState();
}

class _ImportWordsScreenState extends State<ImportWordsScreen> {
  final _controllers = List.generate(NUMBER_OF_WORDS, (index) => TextEditingController());

  @override
  void dispose() {
    super.dispose();
    _controllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => ImportKeyBloc(),
      child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: FlatButtonLong(
                  title: localization.importKeySearchButtonTitle,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<ImportKeyBloc>(context).add(const FindAccountFromWords());
                  },
                  enabled: state.enableButton,
                ),
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
                        localization.importKeyImportUsingRecoveryPhraseTitle,
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
                                _controllers[index] = textEditingController;
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
                      RichText(
                        text: TextSpan(
                          text: "Paste Recovery Words",
                          style: Theme.of(context).textTheme.subtitle2Green2,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final cdata = await Clipboard.getData(Clipboard.kTextPlain);
                              if (!mounted) {
                                return;
                              }
                              final words = (cdata?.text?.split(" ")) ?? [];
                              if (words.length == NUMBER_OF_WORDS) {
                                final FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                for (var index = 0; index < words.length; index++) {
                                  _controllers[index].text = words[index];
                                }
                                BlocProvider.of<ImportKeyBloc>(context).add(OnWordsPasted(words));
                              }
                            },
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (state.userEnteredWords.isEmpty)
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.subtitle2,
                            children: <TextSpan>[
                              TextSpan(
                                text: localization.importKeyImportUsingPrivateKeyActionLink,
                                style: Theme.of(context).textTheme.subtitle2Green2,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                    NavigationService.of(context).navigateTo(Routes.importKey);
                                  },
                              ),
                              const TextSpan(text: " "),
                              TextSpan(text: localization.importKeyImportUsingPrivateKeyDescription),
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
