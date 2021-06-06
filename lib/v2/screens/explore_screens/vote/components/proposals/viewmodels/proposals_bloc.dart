import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote/components/proposals/mappers/proposals_by_scroll_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote/components/proposals/mappers/proposals_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote/components/proposals/usecases/get_proposals_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/vote/components/proposals/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// --- BLOC
class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  ProposalsBloc(ProposalType proposalType) : super(ProposalsState.initial(proposalType));

  @override
  Stream<ProposalsState> mapEventToState(ProposalsEvent event) async* {
    if (event is InitialLoadProposals && state.proposals.isEmpty) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await GetProposalsUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(state, result);
    }
    if (event is LoadProposalsByScroll) {
      Result result = await GetProposalsUseCase().run(state.currentType);
      yield ProposalsByScrollStateMapper().mapResultToState(state, result);
    }
  }
}
