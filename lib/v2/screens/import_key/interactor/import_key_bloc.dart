import 'package:bloc/bloc.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_message_token_repository.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/v2/screens/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/v2/screens/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';

/// --- BLOC
class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  final SettingsNotifier _settingsNotifier;
  final AuthNotifier _authNotifier;
  final AuthenticationBloc _authenticationBloc;

  ImportKeyBloc(this._settingsNotifier, this._authNotifier, this._authenticationBloc) : super(ImportKeyState.initial());

  @override
  Stream<ImportKeyState> mapEventToState(ImportKeyEvent event) async* {
    if (event is FindAccountByKey) {
      yield state.copyWith(pageState: PageState.loading);

      var publicKey = CheckPrivateKeyUseCase().isKeyValid(event.userKey);

      if (publicKey == null || publicKey.isEmpty) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid");
      } else {
        var results = await ImportKeyUseCase().run(publicKey);
        yield ImportKeyStateMapper().mapResultsToState(state, results, event.userKey);
      }
    } else if (event is AccountSelected) {
      // TODO(gguij002): Remove usage of _settingsNotifier and use settingsStorage. We need it for now to not break other areas
      _settingsNotifier.saveAccount(event.account, state.privateKey.toString());
      _settingsNotifier.privateKeyBackedUp = true;

      _authenticationBloc.add(OnImportAccount(account: event.account, privateKey: state.privateKey.toString()));

      await FirebaseMessageTokenRepository().setFirebaseMessageToken(event.account);

      _authNotifier.resetPasscode();
    }
  }
}
