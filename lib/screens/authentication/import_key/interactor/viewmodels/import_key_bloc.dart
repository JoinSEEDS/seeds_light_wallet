import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/import_key/import_key_errors.dart';
import 'package:seeds/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_recovery_words_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_seeds_passport_words_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/utils/result_extension.dart';

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
    final alternatePublicKey =
        event.alternatePrivateKey != null ? CheckPrivateKeyUseCase().isKeyValid(event.alternatePrivateKey!) : null;

    if (publicKey == null || publicKey.isEmpty) {
      emit(state.copyWith(pageState: PageState.failure, error: ImportKeyError.invalidPrivateKey));
    } else {
      final results = await ImportKeyUseCase().run(publicKey);
      final List<Result> alternateResults =
          alternatePublicKey != null ? await ImportKeyUseCase().run(alternatePublicKey) : [];

      emit(
        ImportKeyStateMapper().mapResultsToState(
          currentState: state,
          authData: AuthDataModel.fromKeyAndWords(event.privateKey, event.words),
          results: results,
          alternateAuthData: event.alternatePrivateKey != null
              ? AuthDataModel.fromKeyAndWords(event.alternatePrivateKey!, event.words)
              : null,
          alternateResults: alternateResults,
        ),
      );
    }
  }

  void _onWordChange(OnWordChange event, Emitter<ImportKeyState> emit) {
    final Map<int, String> enteredWords = Map.from(state.userEnteredWords);
    enteredWords[event.wordIndex] = event.word;
    emit(state.copyWith(userEnteredWords: enteredWords, enableButton: state.areAllWordsEntered));
  }

  void _findAccountFromWords(FindAccountFromWords event, Emitter<ImportKeyState> emit) {
    final authData = GenerateKeyFromRecoveryWordsUseCase().run(state.userEnteredWords.values.toList());
    final alternateAuthData = GenerateKeyFromSeedsPassportWordsUseCase().run(state.userEnteredWords.values.toList());
    add(FindAccountByKey(
      privateKey: authData.eOSPrivateKey.toString(),
      alternatePrivateKey: alternateAuthData.eOSPrivateKey.toString(),
      words: authData.words,
    ));
  }
}
