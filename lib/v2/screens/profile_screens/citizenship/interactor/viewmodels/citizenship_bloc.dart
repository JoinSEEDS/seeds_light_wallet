import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/mappers/set_data_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/usecases/get_citizenship_data_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/usecases/get_referred_accounts_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/mappers/set_values_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';

/// --- BLOC
class CitizenshipBloc extends Bloc<CitizenshipEvent, CitizenshipState> {
  CitizenshipBloc() : super(CitizenshipState.initial());

  @override
  Stream<CitizenshipState> mapEventToState(CitizenshipEvent event) async* {
    if (event is SetValues) {
      if (event.profile == null || event.score == null) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
      } else {
        yield state.copyWith(pageState: PageState.loading, profile: event.profile, score: event.score);
        var results = await GetReferredAccountsUseCase().run();
        var results2 = await GetCitizenshipDataUseCase().run();
        yield SetDataStateMapper().mapResultsToState(state, results2);
        yield SetValuesStateMapper().mapResultToState(state, results);
        //yield SetDataStateMapper().mapResultsToState(state, results2);

       // yield ExploreStateMapper().mapResultsToState(state, results);
      }
    }
  }
}
