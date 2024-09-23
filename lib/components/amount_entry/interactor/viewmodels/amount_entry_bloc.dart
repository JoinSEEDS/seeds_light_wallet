import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/currency_change_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/page_commands.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

part 'amount_entry_event.dart';
part 'amount_entry_state.dart';

class AmountEntryBloc extends Bloc<AmountEntryEvent, AmountEntryState> {
  TransferExpertBloc? transferBloc;
  String? fieldName;
  StreamSubscription? transferBlocSubscription;
  late bool xfrBlocAvail;
  AmountEntryBloc(RatesState rates, TokenDataModel tokenDataModel,
   {required this.transferBloc, this.fieldName})
      : super(AmountEntryState.initial(rates, tokenDataModel)) {

    xfrBlocAvail = transferBloc != null;
    if (xfrBlocAvail) {
      transferBlocSubscription = transferBloc!.stream.listen((transferState) {
        String newAmount = "";
        if (fieldName == "from") {
          if (transferState.swapSendAmount!.amount != state.tokenAmount.amount) {
            newAmount = transferState.swapSendAmount!.amountString();
            add(OnPushAmount(amountChanged: newAmount));
          }
        }  else if (fieldName == "to") {
          if (transferState.swapDeliverAmount!.amount != state.tokenAmount.amount) {
            newAmount = transferState.swapDeliverAmount!.amountString();
            add(OnPushAmount(amountChanged: newAmount));
          }
        } 
      });
    };
    on<OnCurrencySwitchButtonTapped>(_onCurrencySwitchButtonTapped);
    on<OnAmountChange>((event, emit) => emit(AmountChangeMapper().mapResultToState(state, event.amountChanged)));
    on<ClearAmountEntryPageCommand>((_, emit) => emit(state.copyWith(pageCommand: NoCommand())));
    on<OnPushAmount>((event, emit) => emit(state.copyWith(pageCommand: PushTextIntoField(event.amountChanged))));
  }

  void _onCurrencySwitchButtonTapped(OnCurrencySwitchButtonTapped event, Emitter<AmountEntryState> emit) {
    emit(CurrencyChangeMapper().mapResultToState(state));
    add(OnAmountChange(amountChanged: state.textInput));
  }

  Future<void> close() {
    transferBlocSubscription?.cancel();
    return super.close();
  }
}
