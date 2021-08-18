import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// The seeds planted
class PlantedModel {
  // Seeds planted
  final double quantity;

  const PlantedModel(this.quantity);

  /// Returns the rounded amount in seeds with its symbol
  String get formattedQuantity => '${quantity.seedsFormatted} $currencySeedsCode';

  /// Returns the rounded amount in seeds
  String get roundedQuantity => quantity.seedsFormatted;

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
