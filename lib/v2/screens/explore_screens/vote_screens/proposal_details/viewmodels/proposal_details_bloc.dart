import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';

/// --- BLOC
class ProposalDetailsBloc extends Bloc<ProposalDetailsEvent, ProposalDetailsState> {
  ProposalDetailsBloc(ProposalsAndIndex proposalsAndIndex) : super(ProposalDetailsState.initial(proposalsAndIndex));

  @override
  Stream<ProposalDetailsState> mapEventToState(ProposalDetailsEvent event) async* {
    if (event is OnNextProposalTapped) {
      yield state.copyWith(
        pageCommand: ReturnToTopScreen(),
        currentIndex: state.currentIndex + 1,
        showNextButton: false,
        isConfirmButtonEnabled: false,
      );
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
