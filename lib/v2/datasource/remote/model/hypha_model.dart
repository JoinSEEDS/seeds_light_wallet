class HyphaModel{
  final int amount;

  HyphaModel(this.amount);

  factory HyphaModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json['rows'].isNotEmpty) {
      return HyphaModel(json['rows'][0]['balance'] as int);
    } else {
      return HyphaModel(2);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HyphaModel && amount == other.amount;

  @override
  int get hashCode => super.hashCode;
}
