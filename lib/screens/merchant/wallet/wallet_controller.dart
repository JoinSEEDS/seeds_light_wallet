import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';

class WalletController extends GetxController {
  BuildContext context;
  WalletController(this.context);

  String balance = "0.0000 SEEDS";
  String accountName = "";

  void onInit() async {
    final balanceProvider = BalanceNotifier.of(context);
    final settingsProvider = SettingsNotifier.of(context);

    settingsProvider.addListener(() {
      accountName = settingsProvider.accountName;
      update();

      balanceProvider.fetchBalance();
    });

    balanceProvider.addListener(() {
      balance = balanceProvider.balance.quantity;
      update();
    });
  }
}
