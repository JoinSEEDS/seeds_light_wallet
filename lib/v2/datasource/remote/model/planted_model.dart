class PlantedModel {
  final String quantity;

  PlantedModel(this.quantity);

  factory PlantedModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json["rows"].isNotEmpty) {
      return PlantedModel(json["rows"][0]["planted"] as String);
    } else {
      return PlantedModel("0.0000 SEEDS");
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlantedModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}