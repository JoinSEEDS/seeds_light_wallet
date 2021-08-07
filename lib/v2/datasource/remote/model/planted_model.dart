import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// The seeds planted
class PlantedModel {
  // Seeds planted
  final double quantity;
  final int rank;

  const PlantedModel(this.quantity, this.rank);

  /// Returns the rounded amount in seeds with its symbol
  String get formattedQuantity => '${quantity.seedsFormatted} $currencySeedsCode';

  /// Returns the rounded amount in seeds
  String get roundedQuantity => '${quantity.seedsFormatted}';

  int get intQuantity => quantity as int;

  factory PlantedModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      var value = json['rows'][0]['planted'] ?? 0.toString();
      var rankString = json['rows'][0]['rank'] ?? 0.toString();
      var amount = double.parse(value.split(' ').first);
      var rank = int.parse(rankString);
      return PlantedModel(amount, rank);
    } else {
      return const PlantedModel(0, 0);
    }
  }
}
