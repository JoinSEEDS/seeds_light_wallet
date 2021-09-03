import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/mappers/seeds_amount_change_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/mappers/user_balance_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/usecases/create_invite_use_case.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/bloc.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';
import 'package:share/share.dart';

import '../mappers/create_invite_result_state_mapper.dart';

/// --- BLOC
class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc(RatesState rates) : super(InviteState.initial(rates));

  @override
  Stream<InviteState> mapEventToState(InviteEvent event) async* {
    if (event is LoadUserBalance) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await GetAvailableBalanceUseCase().run(SeedsToken.parameters());
      yield UserBalanceStateMapper().mapResultToState(state, result, state.ratesState);
    }
    if (event is OnAmountChange) {
      yield SeedsAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged);
    }
    if (event is OnCreateInviteButtonTapped) {
      final String mnemonicSecretCode = generateMnemonic();
      yield state.copyWith(pageState: PageState.loading, isAutoFocus: false, mnemonicSecretCode: mnemonicSecretCode);
      final List<Result> results =
          await CreateInviteUseCase().run(amount: state.tokenAmount.amount, mnemonic: mnemonicSecretCode);
      yield CreateInviteResultStateMapper().mapResultsToState(state, results);
    }
    if (event is OnShareInviteLinkButtonPressed) {
      yield state.copyWith(showCloseDialogButton: true);
      await Share.share(state.dynamicSecretLink!);
    }
  }
}
