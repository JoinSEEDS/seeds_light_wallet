import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/datasource/remote/model/vote_cycle_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/campaign_delegate.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_bloc.dart';
import 'package:seeds/utils/result_extension.dart';

const int _voteCycleResponseIndex = 0;
const int _allianceDelegateResponseIndex = 1;
const int _campaingDelegateResponseIndex = 2;
const int _milestoneDelegateResponseIndex = 3;

class InitialVoteDataStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, List<Result> results) {
    final String moonPhasesError = 'Error loading next moon cycle'.i18n;
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: moonPhasesError);
    } else {
      final isMoonPhasesError = results[_voteCycleResponseIndex].isError;
      if (isMoonPhasesError) {
        return currentState.copyWith(pageState: PageState.failure, errorMessage: moonPhasesError);
      } else {
        final VoteCycleModel voteCycle = results.first.asValue!.value as VoteCycleModel;
        final DelegateModel? allianceDelegate = results[_allianceDelegateResponseIndex].valueOrNull as DelegateModel?;
        final DelegateModel? campaingDelegate = results[_campaingDelegateResponseIndex].valueOrNull as DelegateModel?;
        final DelegateModel? milestoneDelegate = results[_milestoneDelegateResponseIndex].valueOrNull as DelegateModel?;
        final List<CategoryDelegate> currentDelegates = [];
        if (allianceDelegate != null && allianceDelegate.hasDelegate) {
          currentDelegates
              .add(CategoryDelegate(category: ProposalCategory.alliance, delegate: allianceDelegate.delegatee));
        }
        if (campaingDelegate != null && campaingDelegate.hasDelegate) {
          currentDelegates
              .add(CategoryDelegate(category: ProposalCategory.campaign, delegate: campaingDelegate.delegatee));
        }
        if (milestoneDelegate != null && milestoneDelegate.hasDelegate) {
          currentDelegates
              .add(CategoryDelegate(category: ProposalCategory.milestone, delegate: milestoneDelegate.delegatee));
        }

        return currentState.copyWith(
          pageState: PageState.success,
          cycleEndTimestamp: voteCycle.endTime * 1000,
          currentDelegates: currentDelegates,
          voteCycleHasEnded: voteCycle.endTime * 1000 < DateTime.now().millisecondsSinceEpoch,
        );
      }
    }
  }
}
