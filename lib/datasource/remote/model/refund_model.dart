import 'package:equatable/equatable.dart';

class RefundModel extends Equatable {
  final int requestID;
  final int refundID;
  final double amount;
  final int requestTime;
  final int weeksDelay;

  const RefundModel({
    required this.requestID,
    required this.refundID,
    required this.amount,
    required this.requestTime,
    required this.weeksDelay,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      requestID: json['request_id'],
      refundID: json['refund_id'],
      amount: json['amount'],
      requestTime: json['request_time'],
      weeksDelay: json['weeks_delay'],
    );
  }

  @override
  List<Object?> get props => [
        requestID,
        refundID,
        amount,
        requestTime,
        weeksDelay,
      ];
}
