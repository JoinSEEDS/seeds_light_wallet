import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/page_commands.dart';
import '../viewmodels/proposal_details_state.dart';

class NextProposalDataStateMapper extends StateMapper {
  ProposalDetailsState mapResultsToState(ProposalDetailsState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();

      ProfileModel? profileModel = values.firstWhere((i) => i is ProfileModel, orElse: () => null);

      return currentState.copyWith(
        pageState: PageState.success,
        creator: profileModel,
        pageCommand: ReturnToTopScreen(),
        currentIndex: currentState.currentIndex + 1,
        showNextButton: false,
        isConfirmButtonEnabled: false,
      );
    }
  }
}
