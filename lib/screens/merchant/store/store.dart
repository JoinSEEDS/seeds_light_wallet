import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/screens/merchant/store/store_controller.dart';

class MerchantStore extends GetView<StoreController> {
  final StoreController controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) => ListView.builder(
        itemBuilder: (ctx, index) {
          final item = controller.storeItems[index];

          return ListTile(
            onTap: () {},
            title: Text(item.name),
            subtitle: Text(item.price.toString()),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => controller.onPressedEditItem(index),
            ),
          );
        },
        itemCount: controller.storeItems.length,
      ),
    );
  }
}
