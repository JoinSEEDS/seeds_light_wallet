import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/mappers/set_values_mapper.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/usecases/get_citizenship_data_use_case.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/usecases/get_referred_accounts_use_case.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';

/// --- BLOC
class CitizenshipBloc extends Bloc<CitizenshipEvent, CitizenshipState> {
  CitizenshipBloc() : super(CitizenshipState.initial());

  @override
  Stream<CitizenshipState> mapEventToState(CitizenshipEvent event) async* {
    if (event is SetValues) {
      if (event.profile == null) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
      } else {
        yield state.copyWith(pageState: PageState.loading, profile: event.profile);
        final referredAccountResults = await GetReferredAccountsUseCase().run();
        final citizenshipDataResults = await GetCitizenshipDataUseCase().run();
        yield SetValuesStateMapper().mapResultToState(state, referredAccountResults, citizenshipDataResults);
      }
    }
  }
}
