import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/screens/merchant/invoice/invoice.dart';
import 'package:seeds/screens/merchant/merchant_controller.dart';
import 'package:seeds/screens/merchant/pages.dart';
import 'package:seeds/screens/merchant/store/store.dart';
import 'package:seeds/screens/merchant/store/store_controller.dart';
import 'package:seeds/screens/merchant/wallet/wallet.dart';

class Merchant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MerchantController(context),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              child: Center(
                child: Text('Exit Merchant'),
              ),
              onPressed: controller.onPressedExitMerchant,
            ),
          ],
        ),
        body: PageView(
          controller: controller.pageViewController,
          onPageChanged: controller.onPageChanged,
          children: [
            MerchantWallet(),
            MerchantInvoice(),
            MerchantStore(),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.onTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                title: Text('Wallet'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('Invoice'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: Text('Store'),
              ),
            ],
          ),
        ),
        floatingActionButton: Obx(
          () => controller.currentPage.value == Pages.store
              ? FloatingActionButton(
                  onPressed: Get.find<StoreController>().onPressedAddItem,
                  child: Icon(Icons.add),
                )
              : Container(),
        ),
      ),
    );
  }
}
