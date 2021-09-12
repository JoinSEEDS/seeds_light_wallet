import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';

const NUMBER_OF_WORDS = 12;
const NUMBER_OF_COLUMNS = 3;

class RecoveryPhraseScreen extends StatelessWidget {
  const RecoveryPhraseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('12-word Recovery Phrase')),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: FlatButtonLong(
              title: 'I’ve written it down',
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: BlocProvider(
            create: (context) => RecoveryPhraseBloc(),
            child: BlocBuilder<RecoveryPhraseBloc, RecoveryPhraseState>(builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Get a pen and paper before you start. Write down or copy these words in the right order and save them somewhere safe.',
                        style: Theme.of(context).textTheme.subtitle3,
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
                            child: TextField(
                              autocorrect: false,
                              enabled: false,
                              controller: TextEditingController(text: state.words[index]),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: (index + 1).toString(),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }
}
