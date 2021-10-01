import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
const TWELVE_WORDS = 128;

class RecoveryPhraseBloc extends Bloc<SecurityEvent, RecoveryPhraseState> {
  // TODO(gguij002): The words must come from the settings storage
  RecoveryPhraseBloc()
      : super(RecoveryPhraseState.initial(
            "film-survey-erase-lake-field-convince-ceiling-series-grunt-foil-weird-miracle".split("-")));

  @override
  Stream<RecoveryPhraseState> mapEventToState(SecurityEvent event) {
    throw UnimplementedError();
  }
}
