import 'package:equatable/equatable.dart';

class DelegatorModel extends Equatable {
  final String? delegatee;
  final String delegator;

  const DelegatorModel({
    this.delegatee,
    required this.delegator,
  });

  factory DelegatorModel.fromJson(Map<String, dynamic> json) {
    return DelegatorModel(
      delegatee: json['delegatee'],
      delegator: json['delegator'],
    );
  }

  @override
  List<Object?> get props => [
        delegatee,
        delegator,
      ];
}
