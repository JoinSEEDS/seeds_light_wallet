import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/stop_recovery_use_case.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_recovery_words_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_state.dart';

/// --- BLOC
class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  final AuthenticationBloc _authenticationBloc;

  ImportKeyBloc(this._authenticationBloc) : super(ImportKeyState.initial());

  final debugMode = true;

  @override
  Stream<ImportKeyState> mapEventToState(ImportKeyEvent event) async* {
    if (event is FindAccountByKey) {
      yield state.copyWith(pageState: PageState.loading);

      var privateKey = "";
      String? publicKey;

      if (debugMode && event.privateKey.startsWith("EOS")) {
        // this is a public key - support this for debugging our key search
        // this is so we can paste public keys and see if they are found
        // so we can debug users keys without getting their private keys
        final cpuPrivateKey = '5Hy2cvMbrusscGnusLWqYuXyM8fZ65G7DTzs4nDXyiV5wo77n9a';
        privateKey = cpuPrivateKey;
        publicKey = event.privateKey;
      } else {
        privateKey = event.privateKey;
        publicKey = CheckPrivateKeyUseCase().isKeyValid(event.privateKey);
      }

      if (publicKey == null || publicKey.isEmpty) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid".i18n);
      } else {
        final results = await ImportKeyUseCase().run(publicKey);
        yield ImportKeyStateMapper()
            .mapResultsToState(state, results, AuthDataModel.fromKeyAndWords(privateKey, event.words));
      }
    } else if (event is AccountSelected) {
      /// In case there was a recovery in place. We cancel it.
      StopRecoveryUseCase().run();

      _authenticationBloc.add(
        OnImportAccount(account: event.account, authData: state.authData!),
      );
    } else if (event is OnPrivateKeyChange) {
      yield state.copyWith(enableButton: event.privateKeyChanged.isNotEmpty);
    } else if (event is OnWordChange) {
      state.userEnteredWords[event.wordIndex] = event.word;
      yield state.copyWith(userEnteredWords: state.userEnteredWords, enableButton: state.areAllWordsEntered);
    } else if (event is FindAccountFromWords) {
      final authData = GenerateKeyFromRecoveryWordsUseCase().run(state.userEnteredWords.values.toList());
      add(FindAccountByKey(privateKey: authData.eOSPrivateKey.toString(), words: authData.words));
    }
  }
}
