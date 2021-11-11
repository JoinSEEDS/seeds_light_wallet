class DelegatorModel {
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

  List<Object?> get props => [
        delegatee,
        delegator,
      ];
}
