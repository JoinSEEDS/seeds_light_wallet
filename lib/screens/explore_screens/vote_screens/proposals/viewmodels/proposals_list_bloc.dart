import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/mappers/proposals_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/usecases/get_proposals_data_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

part 'proposals_list_event.dart';
part 'proposals_list_state.dart';

class ProposalsListBloc extends Bloc<ProposalsListEvent, ProposalsListState> {
  ProposalsListBloc(ProposalType proposalType) : super(ProposalsListState.initial(proposalType));

  @override
  Stream<ProposalsListState> mapEventToState(ProposalsListEvent event) async* {
    if (event is InitialLoadProposals) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> results = await GetProposalsDataUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results);
    }
    if (event is OnUserProposalsScroll) {
      final List<Result> results = await GetProposalsDataUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results, isScroll: true);
    }
    if (event is OnUserProposalsRefresh) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> results = await GetProposalsDataUseCase().run(state.currentType);
      yield ProposalsStateMapper().mapResultToState(currentState: state, results: results);
    }
    if (event is OnProposalCardTapped) {
      yield state.copyWith(
        pageCommand: NavigateToRouteWithArguments(
          route: Routes.proposalDetails,
          arguments: ProposalsArgsData(
            profile: state.profile!,
            proposals: state.proposals,
            index: event.index,
            currentDelegates: [],
          ),
        ),
      );
    }
    if (event is ClearProposalsListPageCommand) {
      yield state.copyWith();
    }
  }
}
