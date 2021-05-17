import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// The seeds planted
class PlantedModel {
  // Seeds planted
  final double quantity;

  const PlantedModel(this.quantity);

  /// Returns the amount in seeds with its symbol
  String get formattedQuantity => '${quantity.seedsFormatted!} $currencySeedsCode';

  factory PlantedModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      var split = (json['rows'][0]['planted'] as String).split(' ');
      var amount = double.parse(split.first);
      return PlantedModel(amount);
    } else {
      return const PlantedModel(0);
    }
  }
}
