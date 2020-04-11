import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/screens/app/explorer/atm/atm_currency.dart';
import 'package:seeds/widgets/available_balance.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/telos_balance.dart';
import 'package:seeds/widgets/transaction_details.dart';
import 'package:seeds/constants/app_colors.dart';

class Atm extends StatefulWidget {
  Atm({Key key}) : super(key: key);

  @override
  _Atm createState() => _Atm();
}

class _Atm extends State<Atm> {
  final plantController = TextEditingController(text: '1');

  bool transactionSubmitted = false;

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();
  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTransactionForm(),
      ],
    );
  }

  Widget buildTransactionForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AtmCurrency(
                "USD",
                color: AppColors.blue.withOpacity(0.3),
                exchangeRate: "0.123",
              ),
              AtmCurrency(
                "SEEDS",
                color: AppColors.green.withOpacity(0.3),
                exchangeRate: "123",
              ),
              buildFiat(),
              buildSeeds(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFiat() {
    return Column(
      children: <Widget>[
        Text("You..."),
        AtmCurrency(
          "Fiat",
          color: AppColors.blue.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget buildSeeds() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.green.withOpacity(0.3),
      ),
      padding: EdgeInsets.all(7),
      child: Text("test"),
    );
  }

  /*
  sdfsdf dgeInsets.only(bottom: 20, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blue.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(7),
          child:
   */
}

