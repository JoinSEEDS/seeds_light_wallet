import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/datasource/remote/model/firebase_models/push_notification_data.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/load_transactions_use_case.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/mappers/find_paid_transaction_mapper.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';

part 'receive_details_event.dart';
part 'receive_details_state.dart';

class ReceiveDetailsBloc extends Bloc<ReceiveDetailsEvent, ReceiveDetailsState> {
  late StreamSubscription<PushNotificationData> _paymentListener;

  ReceiveDetailsBloc(ReceiveDetails details) : super(ReceiveDetailsState.initial(details)) {
    _paymentListener = PushNotificationService().notificationStream.listen((data) {
      if (data.notificationType != null && data.notificationType == NotificationTypes.paymentReceived) {
        add(OnPaymentReceived(data));
      }
    });
    on<OnPaymentReceived>(_onPaymentReceived);
  }

  @override
  Future<void> close() async {
    await _paymentListener.cancel();
    return super.close();
  }

  Future<void> _onPaymentReceived(OnPaymentReceived event, Emitter<ReceiveDetailsState> emit) async {
    final result = await LoadTransactionsUseCase().run();
    emit(FindPaidTransactionStateMapper().mapResultToState(state, result));
  }
}
