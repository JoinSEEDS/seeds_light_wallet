import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/generic_transaction_model.dart';
import 'package:seeds/utils/read_times_tamp.dart';
import 'package:seeds/utils/string_extension.dart';

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

  static TransactionModel? fromJson(Map<String, dynamic> json) {
    try {
      return TransactionModel(
        from: json['act']['data']['from'],
        to: json['act']['data']['to'],
        quantity: json['act']['data']['quantity'],
        memo: json['act']['data']['memo'],
        timestamp: parseTimestamp(json['@timestamp']),
        transactionId: json['trx_id'],
      );
    }
    catch (e){
      return null;
    }
  }

  factory TransactionModel.fromJsonMongo(Map<String, dynamic> json) {
    return TransactionModel(
      from: json['act']['data']['from'],
      to: json['act']['data']['to'],
      quantity: json['act']['data']['quantity'],
      memo: json['act']['data']['memo'],
      timestamp: parseTimestamp(json['block_time']),
      transactionId: json['trx_id'],
      //json["block_num"], // can add this later - neat but changes cache structure
    );
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
