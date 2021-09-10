import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';

class RecoveryPhraseScreen extends StatelessWidget {
  const RecoveryPhraseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('12-word Recovery Phrase')),
        body: BlocProvider(
            create: (context) => RecoveryPhraseBloc(),
            child: BlocBuilder<RecoveryPhraseBloc, RecoveryPhraseState>(builder: (context, state) {
              return Container();
            })));
  }
}
