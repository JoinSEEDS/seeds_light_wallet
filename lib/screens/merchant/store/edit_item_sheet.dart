import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/screens/merchant/store/store_controller.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class EditItemSheet extends GetView<StoreController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Wrap(
        runSpacing: 10.0,
        children: <Widget>[
          MainTextField(
            labelText: 'Name',
            controller: controller.nameController,
          ),
          MainTextField(
            labelText: 'Price',
            controller: controller.priceController,
            endText: 'SEEDS',
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
          MainButton(
            title: 'Edit Product',
            onPressed: controller.onConfirmedDeleteItem,
          ),
          MainButton(
            title: 'Delete Product',
            onPressed: controller.onConfirmedDeleteItem,
          ),
        ],
      ),
    );
  }
}
