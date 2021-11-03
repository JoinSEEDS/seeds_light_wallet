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

  factory GenericTransactionModel.fromTxData(
    String account,
    String action,
    Map<String, dynamic> data,
    String transactionId,
  ) {
    return GenericTransactionModel(
      transaction: EOSTransaction.fromAction(account: account, actionName: action, data: data),
      transactionId: transactionId,
    );
  }
}
