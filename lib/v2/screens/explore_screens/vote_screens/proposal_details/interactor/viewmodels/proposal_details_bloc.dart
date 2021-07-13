import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import '../mappers/next_proposal_data_state_mapper.dart';
import '../mappers/proposal_data_state_mapper.dart';
import '../usecases/get_proposal_data_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';

/// --- BLOC
class ProposalDetailsBloc extends Bloc<ProposalDetailsEvent, ProposalDetailsState> {
  ProposalDetailsBloc(ProposalsArgsData proposalsArgsData) : super(ProposalDetailsState.initial(proposalsArgsData));

  @override
  Stream<ProposalDetailsState> mapEventToState(ProposalDetailsEvent event) async* {
    if (event is OnLoadProposalData) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalDataUseCase().run(state.proposals[state.currentIndex]);
      yield ProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnNextProposalTapped) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalDataUseCase().run(state.proposals[state.currentIndex + 1]);
      yield NextProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnFavourButtonTapped) {
      yield state.copyWith(voteChoice: VoteChoice.favour);
    }
    if (event is OnAbstainButtonTapped) {
      yield state.copyWith(voteChoice: VoteChoice.abstain);
    }
    if (event is OnAgainstButtonTapped) {
      yield state.copyWith(voteChoice: VoteChoice.against);
    }
    if (event is OnConfirmButtonPressed) {
      yield state.copyWith(showNextButton: true);
    }
  }
}
