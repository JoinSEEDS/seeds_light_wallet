import 'package:meta/meta.dart';
import 'package:seeds/components/snack.dart';
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

class ShowSnackBar extends BusEvent<OnNewTransactionEventBus> {
  final String message;
  final SnackType snackType;

  const ShowSnackBar(this.message) : snackType = SnackType.info;
  const ShowSnackBar.success(this.message) : snackType = SnackType.success;
  const ShowSnackBar.failure(this.message) : snackType = SnackType.failure;
}
