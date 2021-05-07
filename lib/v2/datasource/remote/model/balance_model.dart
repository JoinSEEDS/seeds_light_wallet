import 'package:equatable/equatable.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class BalanceModel extends Equatable {
  final String quantity;
  final double numericQuantity;

  String get formattedQuantity => numericQuantity.seedsFormatted! + ' $currencySeedsCode';
  String get roundedQuantity => numericQuantity.seedsFormatted.toString();

  BalanceModel(this.quantity) : numericQuantity = _parseQuantityString(quantity);

  @override
  List<Object?> get props => [quantity, numericQuantity];

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      return BalanceModel(json[0] as String);
    } else {
      return BalanceModel("0");
    }
  }

  static double _parseQuantityString(String quantityString) {
    return double.parse(quantityString.split(' ')[0]);
  }
}
