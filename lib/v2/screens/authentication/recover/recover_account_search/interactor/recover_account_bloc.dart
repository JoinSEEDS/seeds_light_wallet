import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/mappers/fetch_account_guardians_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/usecases/fetch_account_guardians_use_case.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';

/// --- BLOC
class RecoverAccountBloc extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  RecoverAccountBloc() : super(RecoverAccountState.initial());

  @override
  Stream<RecoverAccountState> mapEventToState(RecoverAccountEvent event) async* {
    if (event is OnUsernameChanged) {
      if (event.userName.length == 12) {
        yield state.copyWith(pageState: PageState.loading);
        var result = await FetchAccountRecoveryUseCase().run(event.userName);
        yield FetchAccountRecoveryStateMapper().mapResultToState(state, result);
      } else {
        yield state.copyWith(isValidUsername: false);
      }
    }
  }
}
