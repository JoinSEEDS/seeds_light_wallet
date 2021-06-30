import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';

/// --- BLOC
class ProposalDetailsBloc extends Bloc<ProposalDetailsEvent, ProposalDetailsState> {
  ProposalDetailsBloc(ProposalsAndIndex proposalsAndIndex) : super(ProposalDetailsState.initial(proposalsAndIndex));

  @override
  Stream<ProposalDetailsState> mapEventToState(ProposalDetailsEvent event) async* {
    if (event is OnNextProposalTapped) {
      yield state.copyWith(currentIndex: state.currentIndex + 1);
    }
    if (event is OnPreviousProposalTapped) {
      yield state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }
}
