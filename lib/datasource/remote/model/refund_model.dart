import 'package:equatable/equatable.dart';

class RefundModel extends Equatable {
  final int refundID;
  final double amount;

  const RefundModel({
    required this.refundID,
    required this.amount,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      refundID: json['refund_id'],
      amount: json['amount'],
    );
  }

  @override
  List<Object?> get props => [
        refundID,
        amount,
      ];
}
