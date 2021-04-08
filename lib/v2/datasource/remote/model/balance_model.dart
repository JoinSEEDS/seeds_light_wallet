import 'package:seeds/utils/double_extension.dart';

class BalanceModel {
  final String quantity;
  final double numericQuantity;

  String get formattedQuantity => numericQuantity == null ? '' : numericQuantity.seedsFormatted + ' SEEDS';
  String get roundedQuantity => numericQuantity == null ? '' : numericQuantity.seedsFormatted.toString();

  BalanceModel(this.quantity) : numericQuantity = _parseQuantityString(quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      return BalanceModel(json[0] as String);
    } else {
      return null;
    }
  }

  static double _parseQuantityString(String quantityString) {
    if (quantityString == null) {
      return 0;
    }
    return double.parse(quantityString.split(' ')[0]);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BalanceModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}
