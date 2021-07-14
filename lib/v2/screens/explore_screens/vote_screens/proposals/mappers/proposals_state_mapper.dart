import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/datasource/remote/model/support_level_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals.i18n.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_list_state.dart';

const String _alliance = 'alliance';
const String _cmp_funding = 'cmp.funding';
const String _cmp_invite = 'cmp.invite';
const String _milestone = 'milestone';

class ProposalsStateMapper extends StateMapper {
  ProposalsListState mapResultToState({
    required ProposalsListState currentState,
    required List<Result> results,
    bool isScroll = false,
  }) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error loading proposals'.i18n);
    } else {
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();
      ProfileModel? profile = values.firstWhere((i) => i is ProfileModel, orElse: () => null);
      List<ProposalModel> proposals = values.firstWhere((i) => i is List<ProposalModel>, orElse: () => null);
      List<ProposalModel> newProposals;

      if (isScroll) {
        // Add the new proposals to current proposals
        newProposals = currentState.proposals + proposals;
      } else {
        newProposals = proposals;
      }

      // Add pass values to proposals by campaing type
      List<List<SupportLevelModel>> supportLevels = values.whereType<List<SupportLevelModel>>().toList();
      SupportLevelModel? allianceLevels = supportLevels[0].first;
      SupportLevelModel? campaingLevels = supportLevels[1].first;
      SupportLevelModel? milestoneLevels = supportLevels[2].first;

      var updatedProposals = newProposals.map((i) {
        if (i.campaignType == _alliance) {
          i = i.copyWith(allianceLevels.voiceNeeded);
        } else if (i.campaignType == _cmp_funding || i.campaignType == _cmp_invite) {
          i = i.copyWith(campaingLevels.voiceNeeded);
        } else if (i.campaignType == _milestone) {
          i = i.copyWith(milestoneLevels.voiceNeeded);
        }
        return i;
      }).toList();
      // If proposals is a empty list then there are no more items to fetch
      return currentState.copyWith(
        pageState: PageState.success,
        profile: profile,
        proposals: updatedProposals,
        hasReachedMax: proposals.isEmpty || proposals.length < 100,
      );
    }
  }
}
