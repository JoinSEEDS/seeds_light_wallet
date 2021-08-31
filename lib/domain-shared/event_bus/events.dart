import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';

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

class OnFiatCurrencyChangedEventBus extends BusEvent<OnNewTransactionEventBus> {
  const OnFiatCurrencyChangedEventBus();
}

class OnAccountChangeEventBus extends BusEvent<OnNewTransactionEventBus> {
  final String oldAccountName;
  final String newAccountName;
  const OnAccountChangeEventBus({required this.oldAccountName, this.newAccountName = ""});

  @override
  String toString() => 'OnAccountChangeEventBus $oldAccountName => $newAccountName';
}
