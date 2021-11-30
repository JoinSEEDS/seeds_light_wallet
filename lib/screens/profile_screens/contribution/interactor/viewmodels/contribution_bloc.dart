import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/mappers/profile_scores_state_mapper.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/usecases/get_profile_scores_use_case.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/bloc.dart';

/// --- BLOC
class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  ContributionBloc() : super(ContributionState.initial());

  @override
  Stream<ContributionState> mapEventToState(ContributionEvent event) async* {
    if (event is SetScores) {
      if (event.score == null) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
      } else {
        yield state.copyWith(pageState: PageState.success, score: event.score);
      }
    } else if (event is FetchScores) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> result = await GetProfileScoresUseCase().run();
      yield ProfileScoresStateMapper().mapResultToState(state, result);
    }
  }
}
