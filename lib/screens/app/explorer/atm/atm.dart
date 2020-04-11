import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/screens/app/explorer/atm/atm_currency.dart';
import 'package:seeds/screens/app/explorer/atm/atm_seller.dart';
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
              WithTitle(
                title: "HELLO",
                child: AtmCurrency(
                  name: "USD",
                  color: AppColors.blue.withOpacity(0.3),
                  exchangeRate: "0.123",
                ),
              ),
              AtmCurrency(
                name: "SEEDS",
                color: AppColors.green.withOpacity(0.3),
                exchangeRate: "123",
              ),
              WithTitle(
                title: "YOU PAY",
                child: AtmCurrency(
                  name: "Fiat",
                  color: AppColors.blue.withOpacity(0.3),
                ),
              ),
              WithTitle(
                title: "SELLERS",
                child: Column(
                  children: <Widget>[
                    AtmSeller(
                      member: MemberModel(
                        account: "astoryteller",
                        nickname: "Nila Phi",
                        //image: "https://seeds-service.s3.amazonaws.com/development/4af2c217-60a2-402e-8ed1-439fd426f5c0/fab347bd-928c-449e-84f5-e162570e5735-1920.jpg",
                      ),
                      color: AppColors.grey.withOpacity(0.3),
                    ),
                    AtmSeller(
                      member: MemberModel(
                        account: "illumination",
                        nickname: "Nik",
                        image: "https://seeds-service.s3.amazonaws.com/development/e46ea503-b743-44b0-901a-4fe07e4d781f/87b2c661-7af6-4b82-9cbe-0a352b5b248c-1920.jpg",
                      ),
                      color: AppColors.grey.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

class WithTitle extends StatelessWidget {

  final String title;
  final Widget child;

  WithTitle({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

