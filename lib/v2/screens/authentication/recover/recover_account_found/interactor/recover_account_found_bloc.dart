import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/mappers/fetch_recover_guardian_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

/// --- BLOC
class RecoverAccountFoundBloc extends Bloc<RecoverAccountFoundEvent, RecoverAccountFoundState> {
  RecoverAccountFoundBloc(List<String> userGuardians) : super(RecoverAccountFoundState.initial(userGuardians));

  @override
  Stream<RecoverAccountFoundState> mapEventToState(RecoverAccountFoundEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(pageState: PageState.loading);
      RecoverGuardianInitialDTO result = await FetchRecoverGuardianInitialDataUseCase().run(state.userGuardians);
      yield FetchRecoverRecoveryStateMapper().mapResultToState(state, result);
    }
  }
}
