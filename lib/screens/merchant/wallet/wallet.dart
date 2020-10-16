import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeds/screens/merchant/wallet/wallet_controller.dart';

class MerchantWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: WalletController(context),
      builder: (controller) => ListView.builder(
        itemBuilder: (ctx, index) {
          final order = controller.orders[index];

          // return ListTile(
          //   title: Text(order.,
          //   subTitle:
          // );
        },
        itemCount: controller.orders.length,
      ),
      // builder: (controller) => Column(
      //   children: <Widget>[
      //     Text(
      //       'Account name',
      //       style: TextStyle(fontFamily: "worksans", fontSize: 25),
      //     ),
      //     Text(
      //       controller.accountName,
      //       style: TextStyle(fontFamily: "worksans", fontSize: 25),
      //     ),
      //     Text(
      //       'Balance',
      //       style: TextStyle(fontFamily: "worksans", fontSize: 25),
      //     ),
      //     Text(
      //       controller.balance,
      //       style: TextStyle(fontFamily: "worksans", fontSize: 25),
      //     ),
      //   ],
      // ),
    );
  }
}
