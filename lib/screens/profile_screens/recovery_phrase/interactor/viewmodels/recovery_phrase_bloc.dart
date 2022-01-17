import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';

part 'recovery_phrase_event.dart';
part 'recovery_phrase_state.dart';

class RecoveryPhraseBloc extends Bloc<RecoveryPhraseEvent, RecoveryPhraseState> {
  RecoveryPhraseBloc()
      : super(RecoveryPhraseState.initial(AuthDataModel.fromKeyAndWords(
          settingsStorage.privateKey!,
          settingsStorage.recoveryWords,
        )));
}
