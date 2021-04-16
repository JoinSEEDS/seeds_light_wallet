import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/models/models.dart';
import 'dart:math';

class LineItem {
  ProductModel? product;
  late int quantity;

  LineItem({this.product, required this.quantity});

  double seedsPrice(CurrencyConverter? converter) {
    return quantity * product!.seedsPrice(converter)!;
  }
}

class CartModel {
  var lineItems = <LineItem>[];
  double donationDiscount = 0; // 0 - 1, negative for discount
  double customAmount = 0;

  bool get isShowProducts => lineItems.isNotEmpty;
  bool get isShowCustom => !isShowProducts;

  CurrencyConverter? currencyConverter;

  LineItem? itemFor(ProductModel? product) {
    return lineItems.firstWhereOrNull((e) => e.product!.name == product!.name);
  }

  int quantityFor(ProductModel product) {
    return itemFor(product)?.quantity ?? 0;
  }

  void add(ProductModel? product) {
    _add(product, 1);
  }

  void remove(ProductModel? product, {deleteOnZero = false}) {
    _add(product, -1, deleteOnZero: deleteOnZero);
  }

  void _add(ProductModel? product, int quantity, {deleteOnZero = false}) {
    var item = itemFor(product);
    if (item != null) {
      item.quantity += quantity;
      item.quantity = max(item.quantity, 0);
      if (deleteOnZero && item.quantity == 0) {
        lineItems.remove(item);
      }
    } else {
      if (quantity > 0) {
        lineItems.add(LineItem(product: product, quantity: quantity));
      }
    }
  }

  void clear() {
    lineItems.clear();
  }

  bool get isEmpty => lineItems.isEmpty;

  int get itemCount => lineItems.fold(0, (p, e) => p + e.quantity);

  double get total =>
      lineItems.isEmpty ? customAmount : lineItems.fold(0, (p, e) => p + e.seedsPrice(currencyConverter));
}
