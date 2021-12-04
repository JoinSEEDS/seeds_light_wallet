import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_recovery_words_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';

part 'import_key_event.dart';
part 'import_key_state.dart';

class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  ImportKeyBloc() : super(ImportKeyState.initial()) {
    on<OnPrivateKeyChange>(_onPrivateKeyChange);
    on<FindAccountByKey>(_findAccountByKey);
    on<OnWordChange>(_onWordChange);
    on<FindAccountFromWords>(_findAccountFromWords);
    on<AccountSelected>((event, emit) => emit(state.copyWith(accountSelected: event.account)));
  }

  void _onPrivateKeyChange(OnPrivateKeyChange event, Emitter<ImportKeyState> emit) {
    emit(state.copyWith(enableButton: event.privateKeyChanged.isNotEmpty));
  }

  Future<void> _findAccountByKey(FindAccountByKey event, Emitter<ImportKeyState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final publicKey = CheckPrivateKeyUseCase().isKeyValid(event.privateKey);
    if (publicKey == null || publicKey.isEmpty) {
      emit(state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid".i18n));
    } else {
      final results = await ImportKeyUseCase().run(publicKey);
      emit(ImportKeyStateMapper()
          .mapResultsToState(state, results, AuthDataModel.fromKeyAndWords(event.privateKey, event.words)));
    }
  }

  void _onWordChange(OnWordChange event, Emitter<ImportKeyState> emit) {
    state.userEnteredWords[event.wordIndex] = event.word;
    emit(state.copyWith(userEnteredWords: state.userEnteredWords, enableButton: state.areAllWordsEntered));
  }

  void _findAccountFromWords(FindAccountFromWords event, Emitter<ImportKeyState> emit) {
    final authData = GenerateKeyFromRecoveryWordsUseCase().run(state.userEnteredWords.values.toList());
    add(FindAccountByKey(privateKey: authData.eOSPrivateKey.toString(), words: authData.words));
  }
}
