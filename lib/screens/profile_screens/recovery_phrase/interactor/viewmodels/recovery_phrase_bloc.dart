import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_state.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class RecoveryPhraseBloc extends Bloc<SecurityEvent, RecoveryPhraseState> {
  RecoveryPhraseBloc()
      : super(RecoveryPhraseState.initial(
            AuthDataModel.fromKeyAndWords(settingsStorage.privateKey!, settingsStorage.getRecoveryWords)));

  @override
  Stream<RecoveryPhraseState> mapEventToState(SecurityEvent event) {
    throw UnimplementedError();
  }
}
