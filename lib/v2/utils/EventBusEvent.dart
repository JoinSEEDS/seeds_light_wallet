import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

/// --- EVENT BUS EVENTS

@immutable
class TransactionSentEventBusEvent {
  final TransactionModel transaction;

  const TransactionSentEventBusEvent(this.transaction);
}
