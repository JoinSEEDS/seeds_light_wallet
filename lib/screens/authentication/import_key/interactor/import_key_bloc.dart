import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/stop_recovery_use_case.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_state.dart';

/// --- BLOC
class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  final AuthenticationBloc _authenticationBloc;

  ImportKeyBloc(this._authenticationBloc) : super(ImportKeyState.initial());

  @override
  Stream<ImportKeyState> mapEventToState(ImportKeyEvent event) async* {
    if (event is FindAccountByKey) {
      yield state.copyWith(pageState: PageState.loading);

      final publicKey = CheckPrivateKeyUseCase().isKeyValid(event.userKey);

      if (publicKey == null || publicKey.isEmpty) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid".i18n);
      } else {
        final results = await ImportKeyUseCase().run(publicKey);
        yield ImportKeyStateMapper().mapResultsToState(state, results, event.userKey);
      }
    } else if (event is AccountSelected) {
      /// In case there was a recovery in place. We cancel it.
      StopRecoveryUseCase().run();

      /// The user entered the app using the Key and not the words. We dont have access to the words.
      _authenticationBloc.add(
        OnImportAccount(account: event.account, authData: AuthDataModel.fromKeyAndNoWords(state.privateKey.toString())),
      );
    } else if (event is OnPrivateKeyChange) {
      yield state.copyWith(enableButton: event.privateKeyChanged.isNotEmpty);
    }
  }
}
