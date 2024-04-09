import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/voice_model.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';

class NextProposalDataStateMapper extends StateMapper {
  ProposalDetailsState mapResultsToState(ProposalDetailsState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      results.retainWhere((Result i) => i.isValue);
      final values = results.map((Result i) => i.asValue!.value).toList();

      final ProfileModel? profileModel = values.firstWhere((i) => i is ProfileModel, orElse: () => null) as ProfileModel?;
      final VoteModel? voteModel = values.firstWhere((i) => i is VoteModel, orElse: () => null) as VoteModel?;
      final VoiceModel? voiceModel = values.firstWhere((i) => i is VoiceModel, orElse: () => null) as VoiceModel?;

      return currentState.copyWith(
        pageState: PageState.success,
        creator: profileModel,
        vote: voteModel,
        tokens: voiceModel,
        pageCommand: ReturnToTopScreen(),
        currentIndex: currentState.currentIndex + 1,
        showNextButton: false,
      );
    }
  }
}
