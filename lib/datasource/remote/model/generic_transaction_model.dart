import 'package:seeds/datasource/local/models/eos_transaction.dart';

class GenericTransactionModel {
  final EOSTransaction transaction;
  final String? transactionId;
  final DateTime? timestamp;

  GenericTransactionModel({
    required this.transaction,
    this.transactionId,
    this.timestamp,
  });
}
