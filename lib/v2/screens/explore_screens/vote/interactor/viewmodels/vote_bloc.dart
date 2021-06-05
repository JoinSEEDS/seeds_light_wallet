import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/usecases/get_proposals_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/mappers/proposals_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/bloc.dart';

/// --- BLOC
class VoteBloc extends Bloc<VoteEvent, VoteState> {
  VoteBloc() : super(VoteState.initial());

  @override
  Stream<VoteState> mapEventToState(VoteEvent event) async* {
    if (event is LoadProposals) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await GetProposalsUseCase().run();
      yield ProposalsStateMapper().mapResultToState(state, result);
    }
    if (event is OnTabChange) {
      yield state.copyWith(currentType: proposalTypes[event.tabIndex]);
      add(const LoadProposals());
    }
  }
}
