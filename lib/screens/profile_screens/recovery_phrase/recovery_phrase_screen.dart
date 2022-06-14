import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_bloc.dart';

const _numberOfWords = 12;
const _numberOfColumns = 3;

class RecoveryPhraseScreen extends StatelessWidget {
  const RecoveryPhraseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('12-word Recovery Phrase')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        child: FlatButtonLong(title: 'I’ve written it down', onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (_) => RecoveryPhraseBloc(),
          child: BlocBuilder<RecoveryPhraseBloc, RecoveryPhraseState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.subtitle2,
                          children: <TextSpan>[
                            const TextSpan(text: 'Get a pen and paper before you start. \nWrite down or '),
                            TextSpan(
                                text: 'copy ',
                                style: Theme.of(context).textTheme.subtitle2Green2,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Clipboard.setData(ClipboardData(text: state.printableWords));
                                    eventBus.fire(const ShowSnackBar.success('Copied'));
                                  }),
                            const TextSpan(text: ' these words in the right order and save them somewhere safe. '),
                          ],
                        ),
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
            },
          ),
        ),
      ),
    );
  }
}
