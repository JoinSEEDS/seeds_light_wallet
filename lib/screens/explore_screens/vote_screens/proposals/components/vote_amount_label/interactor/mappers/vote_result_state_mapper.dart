import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/viewmodels/vote_amount_label_bloc.dart';

class VoteResultStateMapper extends StateMapper {
  VoteAmountLabelState mapResultToState(VoteAmountLabelState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final VoteModel voteModel = result.asValue!.value as VoteModel;

      return currentState.copyWith(pageState: PageState.success, amount: voteModel.amount);
    }
  }
}
