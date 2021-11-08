import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/campaign_delegate.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_bloc.dart';

const String _new_moon = 'New Moon';
const int _moonPhasesResponseIndex = 0;
const int _allianceDelegateResponseIndex = 1;
const int _campaingDelegateResponseIndex = 2;
const int _milestoneDelegateResponseIndex = 3;

class InitialVoteDataStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, List<Result> results) {
    final String moonPhasesError = 'Error loading next moon cycle'.i18n;
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: moonPhasesError);
    } else {
      final isMoonPhasesError = results[_moonPhasesResponseIndex].isError;
      if (isMoonPhasesError) {
        return currentState.copyWith(pageState: PageState.failure, errorMessage: moonPhasesError);
      } else {
        final List<MoonPhaseModel> moonPhases = results.first.asValue!.value;
        final MoonPhaseModel? nextNewMoon = moonPhases.singleWhereOrNull((i) => i.phaseName == _new_moon);
        final DelegateModel? allianceDelegate = results[_allianceDelegateResponseIndex].valueOrNull;
        final DelegateModel? campaingDelegate = results[_campaingDelegateResponseIndex].valueOrNull;
        final DelegateModel? milestoneDelegate = results[_milestoneDelegateResponseIndex].valueOrNull;
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

        if (nextNewMoon != null) {
          return currentState.copyWith(
            remainingTimeStamp: DateTime.parse('${nextNewMoon.time}Z').toLocal().millisecondsSinceEpoch,
            currentDelegates: currentDelegates,
          );
        } else {
          return currentState.copyWith(
            pageState: PageState.failure,
            errorMessage: 'Error loading next moon cycle'.i18n,
          );
        }
      }
    }
  }
}
