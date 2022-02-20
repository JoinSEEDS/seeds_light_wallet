import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/mappers/create_invite_result_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/mappers/seeds_amount_change_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/mappers/user_balance_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/usecases/create_invite_use_case.dart';
import 'package:seeds/screens/explore_screens/invite/invite_errors.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

part 'invite_event.dart';

part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc(RatesState rates) : super(InviteState.initial(rates)) {
    on<LoadUserBalance>(_loadUserBalance);
    on<OnAmountChange>(_onAmountChange);
    on<OnCreateInviteButtonTapped>(_onCreateInviteButtonTapped);
  }

  Future<void> _loadUserBalance(LoadUserBalance event, Emitter<InviteState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<BalanceModel> result = await GetAvailableBalanceUseCase().run(seedsToken);
    emit(UserBalanceStateMapper().mapResultToState(state, result, state.ratesState));
  }

  void _onAmountChange(OnAmountChange event, Emitter<InviteState> emit) {
    emit(SeedsAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged));
  }

  Future<void> _onCreateInviteButtonTapped(OnCreateInviteButtonTapped event, Emitter<InviteState> emit) async {
    final String mnemonicSecretCode = generateMnemonic();
    emit(state.copyWith(pageState: PageState.loading, isAutoFocus: false, mnemonicSecretCode: mnemonicSecretCode));
    final results = await CreateInviteUseCase().run(amount: state.tokenAmount.amount, mnemonic: mnemonicSecretCode);
    emit(CreateInviteResultStateMapper().mapResultsToState(state, results));
  }
}
