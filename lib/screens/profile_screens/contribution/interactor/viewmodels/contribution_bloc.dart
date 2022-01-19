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
    on<ClearContributionPageCommand>((_, emit) => emit(state.copyWith()));
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
                score: state.score?.contributionScore?.value ?? 0,
                scoreType: event.scoreType.value,
                title: ' Your total contribution is measured by combining your other scores. ',
                subtitle:
                    ' It determines how much Trust points you earn for making governance decisions, and also increases how many Seeds you earn from the Harvest by measuring your participation. ')));
        break;
      case ScoreType.transactionScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: state.score?.transactionScore?.value ?? 0,
              scoreType: event.scoreType.value,
              title:
                  ' The more transactions you have, the higher your transaction contribution will be and the more rewards you earn. ',
              subtitle:
                  ' The higher the reputation of the organization you’re buying from, the more points you earn. You only earn points when buying from regenerative organizations, Residents and Citizens. ',
            )));
        break;
      case ScoreType.plantedScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: state.score?.plantedScore?.value ?? 0,
              scoreType: event.scoreType.value,
              title:
                  ' Planted Seeds are similar to a savings account. They are locked up until you unplant them but increase your transaction capacity. ',
              subtitle:
                  ' It determines how much Trust credits you earn for making governance decisions, and also increases how many Seeds you earn from the Harvest by measuring your participation. ',
            )));
        break;
      case ScoreType.reputationScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: state.score?.reputationScore?.value ?? 0,
              scoreType: event.scoreType.value,
              title: ' Your reputation is a multiplier gained by participating in the community. ',
              subtitle:
                  ' Earn reputation by participating in the forum, getting vouched for, inviting new Residents or Citizens, and more. If your reputation is 0, your total contribution is 0 as well.',
            )));
        break;
      case ScoreType.communityScore:
        emit(state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToScoreDetails(
              score: state.score?.communityScore?.value ?? 0,
              scoreType: event.scoreType.value,
              title: ' Your Community score increases as the members you invite become Residents and Citizens. ',
              subtitle:
                  ' You earn more points for your more recent efforts; additional Community points are given based on how many total points you’ve earned and how many of them were earned in the last 3 moons. ',
            )));
    }
  }
}
