import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/mappers/scores_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/usecases/get_scores_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/bloc.dart';

/// --- BLOC
class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  ContributionBloc() : super(ContributionState.initial());

  @override
  Stream<ContributionState> mapEventToState(ContributionEvent event) async* {
    if (event is LoadScores) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await GetScoresUseCase().run();
      yield ScoresStateMapper().mapResultToState(state, result);
    }
  }
}
