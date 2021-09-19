import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/usecases/generate_words_use_case.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
const TWELVE_WORDS = 128;

class RecoveryPhraseBloc extends Bloc<SecurityEvent, RecoveryPhraseState> {
  RecoveryPhraseBloc() : super(RecoveryPhraseState.initial(GenerateWordsUseCase().run()));

  @override
  Stream<RecoveryPhraseState> mapEventToState(SecurityEvent event) {
    throw UnimplementedError();
  }
}
