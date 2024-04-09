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
      requestId: json['request_id'] as int,
      refundId: json['refund_id'] as int,
      amount: double.parse(json['amount'].split(' ').first as String),
      requestTime: json['request_time'] as int,
      weeksDelay: json['weeks_delay'] as int,
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
