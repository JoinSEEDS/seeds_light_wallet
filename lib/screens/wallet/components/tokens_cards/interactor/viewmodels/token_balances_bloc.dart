import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/mappers/token_balances_state_mapper.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/usecases/load_token_balances_use_case.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';

part 'token_balances_event.dart';
part 'token_balances_state.dart';

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
    on<OnLoadTokenBalances>(_onLoadTokenBalances);
    on<OnSelectedTokenChanged>(_onSelectedTokenChanged);
    on<OnFiatCurrencyChanged>(_onFiatCurrencyChanged);
  }

  @override
  Future<void> close() async {
    await eventBusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTokenBalances(OnLoadTokenBalances event, Emitter<TokenBalancesState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final potentialTokens = TokenModel.allTokens;
    final List<Result<BalanceModel>> result = await LoadTokenBalancesUseCase().run(potentialTokens);
    emit(await TokenBalancesStateMapper().mapResultToState(state, potentialTokens, result));
    settingsStorage.selectedToken = state.selectedToken.token;
  }

  void _onSelectedTokenChanged(OnSelectedTokenChanged event, Emitter<TokenBalancesState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
    settingsStorage.selectedToken = state.availableTokens[event.index].token;
  }

  void _onFiatCurrencyChanged(OnFiatCurrencyChanged event, Emitter<TokenBalancesState> emit) {
    emit(state.copyWith(pageState: PageState.loading));
    emit(state.copyWith(pageState: PageState.success));
  }
}
