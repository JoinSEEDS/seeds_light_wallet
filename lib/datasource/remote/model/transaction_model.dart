import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/generic_transaction_model.dart';
import 'package:seeds/utils/read_times_tamp.dart';
import 'package:seeds/utils/string_extension.dart';

// Note: This should be called TransferActionModel - in another PR
class TransactionModel extends Equatable {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final DateTime timestamp;
  final String? transactionId;

  String get symbol => quantity.split(" ")[1];
  double get doubleQuantity => quantity.quantityAsDouble;

  const TransactionModel(
      {required this.from,
      required this.to,
      required this.quantity,
      required this.memo,
      required this.timestamp,
      required this.transactionId});

  @override
  List<Object?> get props => [transactionId];

  static bool validateTokenTransferAction(Map<String, dynamic> json) {
    final data = json['act']?['data'];
    return data?['from'] != null &&
        data?['to'] != null &&
        data?['quantity'] != null &&
        data?['memo'] != null &&
        json['@timestamp'] != null &&
        json['trx_id'] != null;
  }

  static TransactionModel? fromJson(Map<String, dynamic> json) {
    return validateTokenTransferAction(json)
        ? TransactionModel(
            from: json['act']['data']['from'],
            to: json['act']['data']['to'],
            quantity: json['act']['data']['quantity'],
            memo: json['act']['data']['memo'],
            timestamp: parseTimestamp(json['@timestamp']),
            transactionId: json['trx_id'],
          )
        : null;
  }

  static TransactionModel? fromTransaction(GenericTransactionModel genericModel) {
    if (genericModel.transaction.isTransfer) {
      final action = genericModel.transaction.actions.first;
      final data = action.data;
      final String? from = data?['from'];
      final String? to = data?['to'];
      final String? quantity = data?['quantity'];
      final String memo = data?['memo'] ?? "";
      if (from != null && to != null && quantity != null) {
        return TransactionModel(
          from: from,
          to: to,
          quantity: quantity,
          memo: memo,
          timestamp: genericModel.timestamp ?? DateTime.now().toUtc(),
          transactionId: genericModel.transactionId,
        );
      }
    }

    return null;
  }
}
