import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// The available balance of seeds
class BalanceModel {
  /// Seeds available
  final double quantity;

  const BalanceModel(this.quantity);

  /// Returns the rounded amount in seeds with its symbol
  String get formattedQuantity => '${quantity.seedsFormatted} $currencySeedsCode';

  /// Returns the rounded amount in seeds
  String get roundedQuantity => '${quantity.seedsFormatted}';

  factory BalanceModel.fromJson(List<dynamic>? json) {
    if (json != null && json[0].isNotEmpty) {
      var amount = double.parse((json[0] as String).split(' ')[0]);
      return BalanceModel(amount);
    } else {
      return const BalanceModel(0);
    }
  }
}
