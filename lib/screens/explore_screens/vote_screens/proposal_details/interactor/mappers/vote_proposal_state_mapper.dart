import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/page_commands.dart';
import '../viewmodels/proposal_details_state.dart';

class VoteProposalStateMapper extends StateMapper {
  ProposalDetailsState mapResultsToState(ProposalDetailsState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: VoteSuccess(),
        vote: VoteModel(amount: currentState.voteAmount, isVoted: true),
        showNextButton: true,
      );
    }
  }
}
