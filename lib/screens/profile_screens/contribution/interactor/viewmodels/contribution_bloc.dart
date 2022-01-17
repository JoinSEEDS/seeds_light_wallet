import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/mappers/profile_scores_state_mapper.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/usecases/get_profile_scores_use_case.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

part 'contribution_event.dart';

part 'contribution_state.dart';

class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  ContributionBloc() : super(ContributionState.initial()) {
    on<SetScores>(_setScores);
    on<FetchScores>(_fetchScores);
    on<ShowScoreDetails>(_showScoreDetails);
  }

  void _setScores(SetScores event, Emitter<ContributionState> emit) {
    if (event.score == null) {
      emit(state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'));
    } else {
      emit(state.copyWith(pageState: PageState.success, score: event.score));
    }
  }

  Future<void> _fetchScores(FetchScores event, Emitter<ContributionState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final List<Result> result = await GetProfileScoresUseCase().run();
    emit(ProfileScoresStateMapper().mapResultToState(state, result));
  }

  void _showScoreDetails(ShowScoreDetails event, Emitter<ContributionState> emit) {
    switch (event.scoreType) {
      case ScoreType.contributionScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: 0,
              scoreType: 'Todo1',
              title: 'Todo2',
              subtitle: 'Todo3',
            )));
        break;
      case ScoreType.transactionScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: 0,
              scoreType: 'Todo1',
              title: 'Todo2',
              subtitle: 'Todo3',
            )));
        break;
      case ScoreType.plantedScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: 0,
              scoreType: 'Todo1',
              title: 'Todo2',
              subtitle: 'Todo3',
            )));
        break;
      case ScoreType.reputationScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: 0,
              scoreType: 'Todo1',
              title: 'Todo2',
              subtitle: 'Todo3',
            )));
        break;
      case ScoreType.communityScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: 0,
              scoreType: 'Todo1',
              title: 'Todo2',
              subtitle: 'Todo3',
            )));
    }
  }
}
