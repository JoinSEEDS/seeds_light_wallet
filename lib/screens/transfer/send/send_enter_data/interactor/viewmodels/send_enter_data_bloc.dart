import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/mappers/send_amount_change_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/mappers/send_enter_data_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/mappers/send_transaction_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';

part 'send_enter_data_event.dart';
part 'send_enter_data_state.dart';

class SendEnterDataBloc extends Bloc<SendEnterDataEvent, SendEnterDataState> {
  SendEnterDataBloc(ProfileModel memberModel, RatesState rates)
      : super(SendEnterDataState.initial(memberModel, rates)) {
    on<InitSendDataArguments>(_initSendDataArguments);
    on<OnMemoChange>((event, emit) => emit(state.copyWith(memo: event.memoChanged)));
    on<OnAmountChange>(_onAmountChange);
    on<OnNextButtonTapped>(_onNextButtonTapped);
    on<OnSendButtonTapped>(_onSendButtonTapped);
    on<ClearSendEnterDataPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initSendDataArguments(InitSendDataArguments event, Emitter<SendEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: false));
    final Result<BalanceModel> result = await GetAvailableBalanceUseCase().run(settingsStorage.selectedToken);
    emit(SendEnterDataStateMapper().mapResultToState(state, result, state.ratesState, 0.toString()));
  }

  void _onAmountChange(OnAmountChange event, Emitter<SendEnterDataState> emit) {
    emit(SendAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged));
  }

  void _onNextButtonTapped(OnNextButtonTapped event, Emitter<SendEnterDataState> emit) {
    emit(state.copyWith(
      pageState: PageState.success,
      shouldAutoFocusEnterField: false,
      pageCommand: ShowSendConfirmDialog(
        tokenAmount: state.tokenAmount,
        toAccount: state.sendTo.account,
        memo: state.memo,
        toName: state.sendTo.nickname,
        toImage: state.sendTo.image,
        fiatAmount: state.fiatAmount,
      ),
    ));
  }

  Future<void> _onSendButtonTapped(OnSendButtonTapped event, Emitter<SendEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: true));
    final Result result = await SendTransactionUseCase().run(
      EOSTransaction.fromAction(
        account: settingsStorage.selectedToken.contract,
        actionName: transferAction,
        data: {
          'from': settingsStorage.accountName,
          'to': state.sendTo.account,
          'quantity': TokenModel.getAssetString(state.tokenAmount.id, state.tokenAmount.amount),
          'memo': state.memo,
        },
      ),
      null,
    );
    final bool shouldShowInAppReview = await InAppReview.instance.isAvailable();
    emit(SendTransactionMapper().mapResultToState(state, result, shouldShowInAppReview));
  }
}
