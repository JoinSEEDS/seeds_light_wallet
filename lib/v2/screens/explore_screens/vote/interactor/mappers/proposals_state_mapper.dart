import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/vote_state.dart';

class ProposalsStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading proposals".i18n);
    } else {
      ProposalsModel proposalsModel = result.asValue!.value as ProposalsModel;
      Map<String, String> currentType = currentState.currentType!;

      List<ProposalModel> activeProposals = proposalsModel.proposals
          .where((i) => i.stage == currentType['stage'] && i.status == currentType['status'])
          .toList();

      List<ProposalModel> proposals =
          currentType['reverse'] == 'true' ? List<ProposalModel>.from(activeProposals.reversed) : activeProposals;

      return currentState.copyWith(pageState: PageState.success, proposals: proposals);
    }
  }
}
