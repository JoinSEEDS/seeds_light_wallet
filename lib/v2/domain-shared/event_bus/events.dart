import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

/// --- EVENT BUS EVENTS
///
@immutable
abstract class BusEvent<T> {
  const BusEvent();
  @override
  String toString() => 'EventBus { $T }';
}

class OnNewTransactionEventBus extends BusEvent<OnNewTransactionEventBus> {
  final TransactionModel? transactionModel;
  const OnNewTransactionEventBus(this.transactionModel);
}
