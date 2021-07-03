import 'package:seeds/v2/datasource/remote/model/vote_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import '../viewmodels/vote_amount_label_state.dart';

class VoteResultStateMapper extends StateMapper {
  VoteAmountLabelState mapResultToState(VoteAmountLabelState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final VoteModel voteModel = result.asValue!.value;

      return currentState.copyWith(pageState: PageState.success, amount: voteModel.amount);
    }
  }
}
