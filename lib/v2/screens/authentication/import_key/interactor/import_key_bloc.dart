import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

import 'package:seeds/v2/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_state.dart';

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
      _authenticationBloc.add(OnImportAccount(account: event.account, privateKey: state.privateKey.toString()));
    } else if (event is OnPrivateKeyChange) {
      yield state.copyWith(enableButton: event.privateKeyChanged.isNotEmpty);
    }
  }
}
