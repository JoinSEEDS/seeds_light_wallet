import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/mappers/send_amount_change_mapper.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/mappers/send_enter_data_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/usecases/get_available_balance_use_case.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_events.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';

/// --- BLOC
class SendEnterDataPageBloc extends Bloc<SendEnterDataPageEvent, SendEnterDataPageState> {
  SendEnterDataPageBloc(MemberModel memberModel, RatesState rates)
      : super(SendEnterDataPageState.initial(memberModel, rates));

  @override
  Stream<SendEnterDataPageState> mapEventToState(SendEnterDataPageEvent event) async* {
    if (event is InitSendDataArguments) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await GetAvailableBalanceUseCase().run(settingsStorage.accountName);

      yield SendEnterDataStateMapper().mapResultToState(state, result, state.ratesState, "0");
    } else if (event is OnAmountChange) {
      yield SendAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged);
    } else if (event is OnNextButtonTapped) {
      yield state.copyWith(
          pageState: PageState.success,
          showSendConfirmDialog: ShowSendConfirmDialog(
              amount: state.quantity.toString(),
              toAccount: state.sendTo.account,
              memo: "",
              toName: state.sendTo.nickname,
              toImage: state.sendTo.image,
              currency: settingsStorage.selectedFiatCurrency ?? 'USD',
              fiatAmount: state.fiatAmount));
    }
  }
}
