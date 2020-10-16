import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/screens/merchant/pages.dart';

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
}
