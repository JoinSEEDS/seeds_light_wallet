import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/mappers/proposals_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/usecases/get_proposals_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// --- BLOC
class ProposalsListBloc extends Bloc<ProposalsListEvent, ProposalsListState> {
  ProposalsListBloc(ProposalType proposalType) : super(ProposalsListState.initial(proposalType));

  @override
  Stream<ProposalsListState> mapEventToState(ProposalsListEvent event) async* {
    if (event is InitialLoadProposals) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalsUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results);
    }
    if (event is OnUserProposalsScroll) {
      List<Result> results = await GetProposalsUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results, isScroll: true);
    }
    if (event is OnUserProposalsRefresh) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetProposalsUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results);
    }
  }
}
