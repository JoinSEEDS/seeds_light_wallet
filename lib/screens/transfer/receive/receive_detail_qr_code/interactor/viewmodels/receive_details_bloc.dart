import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/datasource/remote/model/firebase_models/push_notification_data.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/shared_use_cases/load_transactions_use_case.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/components/receive_paid_success_dialog.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';
import 'package:seeds/screens/wallet/interactor/usecases/get_user_account.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

part 'receive_details_event.dart';
part 'receive_details_state.dart';

class ReceiveDetailsBloc extends Bloc<ReceiveDetailsEvent, ReceiveDetailsState> {
  late final StreamSubscription<PushNotificationData> _pushNotificationtListener;
  late final StreamSubscription<int> _pollListener;
  final RatesState _rateState;

  ReceiveDetailsBloc(ReceiveDetails details, this._rateState) : super(ReceiveDetailsState.initial(details)) {
    _pushNotificationtListener = PushNotificationService().notificationStream.listen((data) {
      if (data.notificationType != null && data.notificationType == NotificationTypes.paymentReceived) {
        add(const OnPaymentReceived());
      }
    });
    _pollListener =
        Stream.periodic(const Duration(seconds: 5), (x) => x).listen((_) => add(const OnPollCheckPayment()));
    on<OnPaymentReceived>(_checkPayment);
    on<OnPollCheckPayment>(_checkPayment);
    on<OnCheckPaymentButtonPressed>(_checkPayment);
  }

  @override
  Future<void> close() async {
    await _pushNotificationtListener.cancel();
    await _pollListener.cancel();
    return super.close();
  }

  Future<void> _checkPayment(ReceiveDetailsEvent event, Emitter<ReceiveDetailsState> emit) async {
    if (event is OnCheckPaymentButtonPressed) {
      emit(state.copyWith(isCheckButtonLoading: true));
    }
    final result = await LoadTransactionsUseCase().run();
    if (result.isError) {
      emit(state.copyWith()); // Error fetching do nothing
    } else {
      final transations = result.asValue!.value;
      final receivePaymentTransaction = transations.singleWhereOrNull((i) {
        final transactionAmount = double.parse(i.quantity.split(' ').first);
        return i.memo == state.details.memo && transactionAmount == state.details.tokenAmount.amount;
      });
      if (receivePaymentTransaction != null) {
        eventBus.fire(OnNewTransactionEventBus(receivePaymentTransaction)); // update wallet screen values
        final result = await GetUserAccountUseCase().run(receivePaymentTransaction.from);
        if (result.isError) {
          emit(state.copyWith()); // Error fetching do nothing
        } else {
          final token = TokenModel.fromSymbolOrNull(receivePaymentTransaction.symbol);
          FiatDataModel? fiatData;
          if (token != null) {
            fiatData = _rateState.tokenToFiat(
              TokenDataModel(receivePaymentTransaction.doubleQuantity, token: token),
              settingsStorage.selectedFiatCurrency,
            );
          }
          emit(state.copyWith(
              receivePaidSuccessArgs: ReceivePaidSuccessArgs(
            receivePaymentTransaction,
            result.asValue!.value,
            fiatData,
          )));
        }
      }
    }
    if (event is OnCheckPaymentButtonPressed) {
      emit(state.copyWith(isCheckButtonLoading: false));
    }
  }
}
