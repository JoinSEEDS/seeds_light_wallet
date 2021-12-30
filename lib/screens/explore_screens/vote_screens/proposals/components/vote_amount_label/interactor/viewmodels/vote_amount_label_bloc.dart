import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/mappers/vote_result_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/usecases/get_vote_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

part 'vote_amount_label_event.dart';
part 'vote_amount_label_state.dart';

class VoteAmountLabelBloc extends Bloc<VoteAmountLabelEvent, VoteAmountLabelState> {
  VoteAmountLabelBloc() : super(VoteAmountLabelState.initial()) {
    on<LoadVoteAmount>(_loadVoteAmount);
  }

  Future<void> _loadVoteAmount(LoadVoteAmount event, Emitter<VoteAmountLabelState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await GetVoteUseCase().run(event.proposal, settingsStorage.accountName);
    emit(VoteResultStateMapper().mapResultToState(state, result));
  }
}
