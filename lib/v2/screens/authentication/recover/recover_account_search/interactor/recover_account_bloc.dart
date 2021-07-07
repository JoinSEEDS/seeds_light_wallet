import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/mappers/fetch_account_guardians_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/mappers/fetch_account_info_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/usecases/fetch_account_guardians_use_case.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/usecases/fetch_account_info_use_case.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';

/// --- BLOC
class RecoverAccountBloc extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  RecoverAccountBloc() : super(RecoverAccountState.initial());

  @override
  Stream<RecoverAccountState> mapEventToState(RecoverAccountEvent event) async* {
    if (event is OnUsernameChanged) {
      if (event.userName.length == 12) {
        yield state.copyWith(pageState: PageState.loading);
        var userInfo = await FetchAccountInfoUseCase().run(event.userName);
        var result = await FetchAccountRecoveryUseCase().run(event.userName);

        yield FetchAccountRecoveryStateMapper().mapResultToState(state, result, event.userName);
        yield FetchAccountInfoStateMapper().mapResultToState(state, userInfo, event.userName);
      } else {
        yield state.copyWith(isGuardianActive: false, isValidAccount: false);
      }
    } else if (event is OnNextButtonTapped) {
      yield state.copyWith(pageCommand: NavigateToRecoverAccountFound(Input(state.userGuardians, state.userName!)));
    }
  }
}
