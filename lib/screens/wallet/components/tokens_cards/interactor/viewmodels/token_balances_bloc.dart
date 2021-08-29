import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/mappers/token_balances_state_mapper.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/usecases/load_token_balances_use_case.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_event.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_state.dart';

/// --- BLOC
class TokenBalancesBloc extends Bloc<TokenBalancesEvent, TokenBalancesState> {
  StreamSubscription? eventBusSubscription;

  TokenBalancesBloc() : super(TokenBalancesState.initial()) {
    eventBusSubscription = eventBus.on().listen((event) async {
      if (event is OnNewTransactionEventBus) {
        await Future.delayed(const Duration(milliseconds: 500)); // the blockchain needs 0.5 seconds to process
        add(const OnLoadTokenBalances());
      } else if (event is OnFiatCurrencyChangedEventBus) {
        add(const OnFiatCurrencyChanged());
      }
    });
  }

  @override
  Future<void> close() async {
    await eventBusSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TokenBalancesState> mapEventToState(TokenBalancesEvent event) async* {
    if (event is OnLoadTokenBalances) {
      yield state.copyWith(pageState: PageState.loading);

      final potentialTokens = TokenModel.AllTokens;

      final result = await LoadTokenBalancesUseCase().run(potentialTokens);

      yield await TokenBalancesStateMapper().mapResultToState(state, potentialTokens, result);
    } else if (event is OnSelectedTokenChanged) {
      yield state.copyWith(selectedIndex: event.index);
      settingsStorage.selectedToken = state.availableTokens[event.index].token;
    } else if (event is OnFiatCurrencyChanged) {
      yield state.copyWith(pageState: PageState.loading);
      yield state.copyWith(pageState: PageState.success);
    }
  }
}
