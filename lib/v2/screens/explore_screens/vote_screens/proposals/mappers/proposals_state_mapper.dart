import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/datasource/remote/model/support_level_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_list_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

const _alliance = 'alliance';
const _cmp_funding = 'cmp.funding';
const _milestone = 'milestone';

class ProposalsStateMapper extends StateMapper {
  ProposalsListState mapResultToState(ProposalsListState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading proposals".i18n);
    } else {
      print('ProposalsStateMapper mapResultsToState length = ${results.length}');
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();

      List<ProposalModel> proposals = values.firstWhere((i) => i is List<ProposalModel>, orElse: () => null);

      ProposalType currentType = currentState.currentType;
      List<ProposalModel> filtered = [];
      // Filter proposals by proposal section type
      if (currentType.status.length == 1) {
        filtered =
            proposals.where((i) => i.stage == currentType.stage && i.status == currentType.status.first).toList();
      } else {
        // History covers 2 status, proposals with (passed, rejected) status are part of history list.
        filtered = proposals
            .where((i) =>
                i.stage == currentType.stage &&
                (i.status == currentType.status.first || i.status == currentType.status.last))
            .toList();
      }
      // Check if the list needs sort
      List<ProposalModel> newProposals = currentType.isReverse ? List<ProposalModel>.from(filtered.reversed) : filtered;

      // Add pass values to proposals by campaing type
      List<List<SupportLevelModel>> supportLevels = values.whereType<List<SupportLevelModel>>().toList();
      SupportLevelModel? allianceLevels = supportLevels[0].first;
      SupportLevelModel? campaingLevels = supportLevels[1].first;
      SupportLevelModel? milestoneLevels = supportLevels[2].first;

      var updatedProposals = newProposals.map((i) {
        if (i.campaignType == _alliance) {
          i = i.copyWith(allianceLevels.voiceNeeded);
        } else if (i.campaignType == _cmp_funding) {
          i = i.copyWith(campaingLevels.voiceNeeded);
        } else if (i.campaignType == _milestone) {
          i = i.copyWith(milestoneLevels.voiceNeeded);
        }
        return i;
      }).toList();

      return currentState.copyWith(pageState: PageState.success, proposals: updatedProposals);
    }
  }
}
