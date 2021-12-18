import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/mappers/vote_result_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/usecases/get_vote_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/viewmodels/bloc.dart';

/// --- BLOC
class VoteAmountLabelBloc extends Bloc<VoteAmountLabelEvent, VoteAmountLabelState> {
  VoteAmountLabelBloc() : super(VoteAmountLabelState.initial());

  @override
  Stream<VoteAmountLabelState> mapEventToState(VoteAmountLabelEvent event) async* {
    if (event is LoadVoteAmount) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await GetVoteUseCase().run(event.proposal, settingsStorage.accountName);
      yield VoteResultStateMapper().mapResultToState(state, result);
    }
  }
}
