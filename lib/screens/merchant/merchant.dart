import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

enum Pages {
  wallet,
  invoice,
  store,
}

class WalletController extends GetxController {
  BuildContext context;
  WalletController(this.context);

  final balance = "0.0000 SEEDS".obs;
  final accountName = "".obs;

  void onInit() async {
    final balanceProvider = BalanceNotifier.of(context);
    final settingsProvider = SettingsNotifier.of(context);

    settingsProvider.addListener(() {
      accountName.value = settingsProvider.accountName;
      balanceProvider.fetchBalance();
    });

    balanceProvider.addListener(() {
      balance.value = balanceProvider.balance.quantity;
    });
  }
}

class StoreController extends GetxController {
  Box<ItemModel> box;

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
    final item = ItemModel(
      name: nameController.text,
      price: double.parse(priceController.text),
    );

    box.add(item);

    update();

    Get.close(1);
  }

  var editingItemIdx = 0;

  void onPressedEditItem(int index) {
    editingItemIdx = index;

    Get.bottomSheet(
      EditItem(),
    );
  }

  final storeItems = List<ItemModel>();
}

class MerchantController extends GetxController {
  BuildContext context;
  MerchantController(this.context);

  final pageViewController = PageController(initialPage: 2);

  final currentPage = Pages.store.obs;

  int get currentIndex {
    switch (currentPage.value) {
      case Pages.wallet:
        return 0;
      case Pages.invoice:
        return 1;
      default:
        return 2;
    }
  }

  void onPressedExitMerchant() {
    SettingsNotifier.of(context, listen: false).disableMerchantMode();
  }

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        currentPage.value = Pages.wallet;
        break;
      case 1:
        currentPage.value = Pages.invoice;
        break;
      case 2:
        currentPage.value = Pages.store;
        break;
    }
  }

  void onTap(int index) {
    onPageChanged(index);

    pageViewController.animateToPage(
      index,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void onPressedActionButton() {
    Get.bottomSheet(StoreBottomSheet());
  }
}

class MerchantWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: WalletController(context),
      builder: (controller) => Column(
        children: <Widget>[
          Text(
            'Balance',
            style: TextStyle(fontFamily: "worksans", fontSize: 25),
          ),
          Text(
            controller.balance.value,
            style: TextStyle(fontFamily: "worksans", fontSize: 25),
          ),
        ],
      ),
    );
  }
}

class MerchantStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StoreController(),
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

class MerchantInvoice extends StatelessWidget {
  final MerchantController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
                  onPressed: controller.onPressedActionButton,
                  child: Icon(Icons.add),
                )
              : Container(),
        ),
      ),
    );
  }
}

class EditItemController extends GetxController {
  final StoreController storeController = Get.find();

  List<ItemModel> get storeItems => storeController.storeItems;
  Box<ItemModel> get box => storeController.box;
  int get itemIdx => storeController.editingItemIdx;

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  void onInit() {
    nameController.text = storeItems[itemIdx].name;
    priceController.text = storeItems[itemIdx].price.toString();
  }

  void onPressedEditItem() {
    final name = nameController.text;

    final item = box.getAt(itemIdx);
    item.name = name;
    item.price = double.parse(priceController.text);
    item.save();

    Get.close(1);
  }

  void onPressedDeleteItem() {
    box.deleteAt(itemIdx);

    Get.close(1);
  }
}

class EditItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditItemController(),
      builder: (controller) => Container(
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
              onPressed: controller.onPressedEditItem,
            ),
            MainButton(
              title: 'Delete Product',
              onPressed: controller.onPressedDeleteItem,
            ),
          ],
        ),
      ),
    );
  }
}

class StoreBottomSheet extends StatelessWidget {
  final StoreController controller = Get.find();

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
            title: 'Add Product',
            onPressed: controller.onPressedAddItem,
          ),
        ],
      ),
    );
  }
}
