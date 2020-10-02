import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';

class ItemsNotifier extends ChangeNotifier {
  List<ItemModel> items;

  Future<void> loadItems() async {
    items = (await Hive.openBox<ItemModel>("items")).values.toList();
    notifyListeners();
  }

  Future<void> addItem(ItemModel item) async {
    (await Hive.openBox<ItemModel>("items")).put(
      item.name,
      item,
    );
  }
}
