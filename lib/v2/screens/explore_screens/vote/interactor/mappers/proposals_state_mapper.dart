import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/proposal_type_model.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/vote_state.dart';

class ProposalsStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading proposals".i18n);
    } else {
      ProposalsModel proposalsModel = result.asValue!.value;
      ProposalType currentType = currentState.currentType;
      List<ProposalModel> filtered = [];
      proposalsModel.proposals.forEach((i) => print(i.stage));
      // Filter proposals by section type
      if (currentType.status.length == 1) {
        filtered = proposalsModel.proposals
            .where((i) => i.stage == currentType.stage && i.status == currentType.status.first)
            .toList();
      } else {
        // History covers 2 status
        filtered = proposalsModel.proposals
            .where((i) =>
                i.stage == currentType.stage &&
                (i.status == currentType.status.first || i.status == currentType.status.last))
            .toList();
      }

      List<ProposalModel> proposals = currentType.isReverse ? List<ProposalModel>.from(filtered.reversed) : filtered;

      return currentState.copyWith(pageState: PageState.success, proposals: proposals);
    }
  }
}
