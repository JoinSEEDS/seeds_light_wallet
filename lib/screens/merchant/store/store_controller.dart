import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/screens/merchant/store/add_item_sheet.dart';
import 'package:seeds/screens/merchant/store/edit_item_sheet.dart';

class StoreController extends GetxController {
  int editingItemIdx = 0;

  Box<ItemModel> box;
  final storeItems = List<ItemModel>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void onInit() async {
    box = await Hive.openBox<ItemModel>("items");

    storeItems.addAll(box.values);
    update();

    box.watch().listen((event) {
      storeItems.clear();
      storeItems.addAll(box.values);
      update();
    });
  }

  void onPressedAddItem() {
    nameController.clear();
    priceController.clear();

    Get.bottomSheet(AddItemSheet());
  }

  void onPressedEditItem(int index) {
    editingItemIdx = index;
    nameController.text = storeItems[index].name;
    priceController.text = storeItems[index].price.toString();

    Get.bottomSheet(EditItemSheet());
  }

  void onConfirmedAddItem() {
    final item = ItemModel(
      name: nameController.text,
      price: double.parse(priceController.text),
    );

    box.add(item);

    Get.close(1);
  }

  void onConfirmedEditItem() {
    final name = nameController.text;

    final item = box.getAt(editingItemIdx);
    item.name = name;
    item.price = double.parse(priceController.text);
    item.save();

    Get.close(1);
  }

  void onConfirmedDeleteItem() {
    box.deleteAt(editingItemIdx);

    Get.close(1);
  }
}
