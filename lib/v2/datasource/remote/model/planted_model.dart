class PlantedModel {
  final double quantity;

  PlantedModel(this.quantity);

  factory PlantedModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json["rows"].isNotEmpty) {
      var split = (json["rows"][0]["planted"] as String).split(" ");
      var amount = double.parse(split.first);
      return PlantedModel(amount);
    } else {
      return PlantedModel(0);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PlantedModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}
