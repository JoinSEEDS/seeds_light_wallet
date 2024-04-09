class DelegatorModel {
  final String? delegatee;
  final String delegator;

  const DelegatorModel({this.delegatee, required this.delegator});

  factory DelegatorModel.fromJson(Map<String, dynamic> json) {
    return DelegatorModel(delegatee: json['delegatee'] as String, delegator: json['delegator'] as String);
  }
}
