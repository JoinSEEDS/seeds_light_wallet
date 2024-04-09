import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/campaign_delegate.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_bloc.dart';
import 'package:seeds/utils/result_extension.dart';

const int _allianceDelegateResponseIndex = 0;
const int _campaingDelegateResponseIndex = 1;
const int _milestoneDelegateResponseIndex = 2;

class AllDelegatesStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
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

      return currentState.copyWith(currentDelegates: currentDelegates);
    }
  }
}
