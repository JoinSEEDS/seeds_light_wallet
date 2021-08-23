/// The seeds planted
class PlantedModel {
  // Seeds planted
  final double quantity;

  const PlantedModel(this.quantity);

  factory PlantedModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final value = json['rows'][0]['planted'] ?? 0.toString();
      final amount = double.parse(value.split(' ').first);
      return PlantedModel(amount);
    } else {
      return const PlantedModel(0);
    }
  }
}
