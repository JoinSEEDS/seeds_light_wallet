import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/invite/interactor/viewmodels/bloc.dart';

import '../../../../../datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

/// --- BLOC
class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc(RatesState rates) : super(InviteState.initial(rates));

  @override
  Stream<InviteState> mapEventToState(InviteEvent event) async* {
    if (event is LoadUserBalance) {
      // just placeholder data
      yield state.copyWith(
        pageState: PageState.success,
        fiatAmount: state.ratesState.currencyString(0, 'USD'),
        availableBalance: const BalanceModel(0),
        availableBalanceFiat: state.ratesState.currencyString(0, 'USD'),
      );
    }
    if (event is OnAmountChange) {
      // next pr
    }
    if (event is OnCreateInviteButtonTapped) {
      // next pr
    }
  }
}
