import 'package:bloc/bloc.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_message_token_repository.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/claim_invite_code/interactor/viewmodels/claim_invite_code_events.dart';
import 'package:seeds/v2/screens/claim_invite_code/interactor/viewmodels/claim_invite_code_state.dart';

/// --- BLOC
class ClaimInviteCodeBloc extends Bloc<ClaimInviteCodeEvent, ClaimInviteCodeState> {
  final SettingsNotifier _settingsNotifier;
  final AuthNotifier _authNotifier;

  ClaimInviteCodeBloc(this._settingsNotifier, this._authNotifier) : super(ClaimInviteCodeState.initial());

  @override
  Stream<ClaimInviteCodeState> mapEventToState(ClaimInviteCodeEvent event) async* {
    if (event is FindAccountByKey) {
      yield state.copyWith(pageState: PageState.loading);

     // var publicKey = CheckPrivateKeyUseCase().isKeyValid(event.userKey);

      //if (publicKey == null || publicKey.isEmpty) {
       // yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid");
      // } else {
      //   var results = await ImportKeyUseCase().run(publicKey);
      //   yield ImportKeyStateMapper().mapResultsToState(state, results, event.userKey);
      // }
    } else if (event is AccountSelected) {
      // TODO(gguij002): Remove usage of _settingsNotifier and use settingsStorage. We need it for now to not break other areas
      _settingsNotifier.saveAccount(event.account, state.privateKey.toString());
      _settingsNotifier.privateKeyBackedUp = true;

      settingsStorage.saveAccount(event.account, state.privateKey.toString());
      settingsStorage.privateKeyBackedUp = true;

      await FirebaseMessageTokenRepository().setFirebaseMessageToken(event.account);

      _authNotifier.resetPasscode();
    }
  }
}
