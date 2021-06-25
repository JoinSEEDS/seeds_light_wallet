import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// The available balance of seeds
class BalanceModel {
  final double quantity;
  final bool hasBalance;

  const BalanceModel(this.quantity, {this.hasBalance = true});

  /// Returns the rounded amount in seeds with its symbol
  String get formattedQuantity => '${quantity.seedsFormatted} $currencySeedsCode';

  /// Returns the rounded amount in seeds
  String get roundedQuantity => '${quantity.seedsFormatted}';

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isEmpty || json[0].isEmpty) {
      return const BalanceModel(0, hasBalance: false);
    } else {
      var amount = double.parse((json[0] as String).split(' ').first);
      return BalanceModel(amount);
    }
  }
}
