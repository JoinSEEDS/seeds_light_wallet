import 'package:async/async.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details_bloc.dart';

class FindPaidTransactionStateMapper {
  ReceiveDetailsState mapResultToState(ReceiveDetailsState currentState, Result result) {
    if (result.isError) {
      return currentState;
    } else {
      final transations = result.asValue!.value as List<TransactionModel>;

      final receivePayment = transations.singleWhereOrNull((i) {
        final transactionAmount = double.parse(i.quantity.split(' ').first);
        return i.memo == currentState.details.memo && transactionAmount == currentState.details.tokenAmount.amount;
      });
      if (receivePayment != null) {
        return currentState.copyWith(receivePaidTransaction: receivePayment);
      } else {
        return currentState;
      }
    }
  }
}
