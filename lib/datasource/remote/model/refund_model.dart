import 'package:seeds/datasource/local/models/token_data_model.dart';

/// Seeds that in the process of being unplanted
class RefundModel {
  final int requestId;
  final int refundId;
  final String account;
  final TokenDataModel amount;
  final int weeksDelay;
  final int requestTime;

  const RefundModel({
    required this.requestId,
    required this.refundId,
    required this.account,
    required this.amount,
    required this.weeksDelay,
    required this.requestTime,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    final amount = double.parse(json['amount'].split(' ').first);
    return RefundModel(
      requestId: json['request_id'],
      refundId: json['refund_id'],
      account: json['account'],
      amount: TokenDataModel.from(amount)!,
      weeksDelay: json['weeks_delay'],
      requestTime: json['request_time'],
    );
  }
}
