import 'package:equatable/equatable.dart';

class RefundModel extends Equatable {
  final int requestId;
  final int refundId;
  final double amount;
  final int requestTime;
  final int weeksDelay;

  const RefundModel({
    required this.requestId,
    required this.refundId,
    required this.amount,
    required this.requestTime,
    required this.weeksDelay,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      requestId: json['request_id'],
      refundId: json['refund_id'],
      amount: double.parse(json['amount'].split(' ').first),
      requestTime: json['request_time'],
      weeksDelay: json['weeks_delay'],
    );
  }

  @override
  List<Object?> get props => [
        requestId,
        refundId,
        amount,
        requestTime,
        weeksDelay,
      ];
}
