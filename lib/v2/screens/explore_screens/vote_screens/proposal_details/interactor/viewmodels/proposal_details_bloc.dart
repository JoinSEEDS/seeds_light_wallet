import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import '../mappers/next_proposal_data_state_mapper.dart';
import '../mappers/proposal_data_state_mapper.dart';
import '../usecases/get_proposal_data_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';

/// --- BLOC
class ProposalDetailsBloc extends Bloc<ProposalDetailsEvent, ProposalDetailsState> {
  ProposalDetailsBloc(ProposalsAndIndex proposalsAndIndex) : super(ProposalDetailsState.initial(proposalsAndIndex));

  @override
  Stream<ProposalDetailsState> mapEventToState(ProposalDetailsEvent event) async* {
    if (event is OnLoadProposalData) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalDataUseCase().run(
        creatorAccount: state.proposals[state.currentIndex].creator,
        proposalId: state.proposals[state.currentIndex].id,
      );
      yield ProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnNextProposalTapped) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalDataUseCase().run(
        creatorAccount: state.proposals[state.currentIndex + 1].creator,
        proposalId: state.proposals[state.currentIndex + 1].id,
      );
      yield NextProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnFavourButtonTapped) {
      yield state.copyWith(isConfirmButtonEnabled: true);
    }
    if (event is OnAbstainButtonTapped) {
      yield state.copyWith(isConfirmButtonEnabled: true);
    }
    if (event is OnAgainstButtonTapped) {
      yield state.copyWith(isConfirmButtonEnabled: true);
    }
    if (event is OnConfirmButtonPressed) {
      yield state.copyWith(showNextButton: true);
    }
  }
}
