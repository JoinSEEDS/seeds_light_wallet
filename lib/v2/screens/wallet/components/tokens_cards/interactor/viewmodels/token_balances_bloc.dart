import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/mappers/token_balances_state_mapper.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/usecases/load_token_balances_use_case.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_event.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_state.dart';

/// --- BLOC
class TokenBalancesBloc extends Bloc<TokenBalancesEvent, TokenBalancesState> {
  TokenBalancesBloc() : super(TokenBalancesState.initial());

  @override
  Stream<TokenBalancesState> mapEventToState(TokenBalancesEvent event) async* {
    if (event is OnLoadTokenBalances) {
      yield state.copyWith(pageState: PageState.loading);

      const potentialTokens = [SeedsToken, HusdToken, HyphaToken, LocalScaleToken];

      var result = await LoadTokenBalancesUseCase().run(potentialTokens);

      yield TokenBalancesStateMapper().mapResultToState(state, potentialTokens, result);
    } else if (event is OnSelectedTokenChanged) {
      yield state.copyWith(selectedIndex: event.index);
    }
  }
}
