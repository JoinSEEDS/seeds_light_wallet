import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import '../viewmodels/proposal_details_state.dart';

class ProposalDetailsDataStateMapper extends StateMapper {
  ProposalDetailsState mapResultsToState(ProposalDetailsState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      print('ProposalDetailsDataStateMapper mapResultsToState length=' + results.length.toString());
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();

      ProfileModel? profileModel = values.firstWhere((i) => i is ProfileModel, orElse: () => null);

      return currentState.copyWith(pageState: PageState.success, creator: profileModel);
    }
  }
}
