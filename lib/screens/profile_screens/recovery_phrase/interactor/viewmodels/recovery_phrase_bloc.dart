import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/bloc.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

/// --- BLOC
const TWELVE_WORDS = 128;
class RecoveryPhraseBloc extends Bloc<SecurityEvent, RecoveryPhraseState> {
  RecoveryPhraseBloc() : super(RecoveryPhraseState.initial(generateWords()));

  @override
  Stream<RecoveryPhraseState> mapEventToState(SecurityEvent event) {
    throw UnimplementedError();
  }
}

List<String> generateWords() {
  final String mnemonicSecretCode = generateMnemonic(strength: TWELVE_WORDS);
  return mnemonicSecretCode.split('-');
}
