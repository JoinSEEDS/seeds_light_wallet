import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/available_balance.dart';
import 'package:seeds/widgets/bracelet_balance.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/planted_balance.dart';
import 'package:seeds/widgets/transaction_details.dart';
import 'package:seeds/i18n/harvest.i18n.dart';

class Bracelet extends StatefulWidget {
  Bracelet({Key key}) : super(key: key);

  @override
  _BraceletState createState() => _BraceletState();
}

class _BraceletState extends State<Bracelet> {
  final plantController = TextEditingController(text: '1');

  bool transactionSubmitted = false;
  bool pinEnabled = false;
  bool frozen = false;

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();
  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  @override
  void dispose() {
    _statusNotifier.close();
    _messageNotifier.close();
    super.dispose();
  }

  void onTopUp() async {
    print("on top up");
  }

  void onRefund() async {
    print("on refund");
  }

  Widget buildProgressOverlay() {
    return FullscreenLoader(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
      successButtonText: "Success!".i18n,
      failureButtonCallback: () {
        setState(() {
          transactionSubmitted = false;
        });
        Navigator.of(context).maybePop();
      },
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
              TransactionDetails(
                image: SvgPicture.asset("assets/images/harvest.svg"),
                title: "Bracelet".i18n,
                beneficiary: "",
              ),
              AvailableBalance(),
              BraceletBalance(),
              MainTextField(
                keyboardType: TextInputType.number,
                controller: plantController,
                labelText: 'Top up amount'.i18n,
                endText: 'SEEDS',
              ),
              MainButton(
                margin: EdgeInsets.only(top: 25),
                title: 'Top up Bracelet',
                onPressed: onTopUp,
              ),
              MainButton(
                margin: EdgeInsets.only(top: 25),
                title: 'Refund',
                onPressed: onRefund,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enable Pin Code"),
                        Switch(value: pinEnabled, onChanged: onPinSwitch),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Freeze"),
                        Switch(value: frozen, onChanged: onFreeze),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPinSwitch(bool value) {
    print("onPinSwitch");
    setState(() {
      pinEnabled = !pinEnabled;
    });
  }

  void onFreeze(bool value) {
    print("onFreeze");
    setState(() {
      frozen = !frozen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTransactionForm(),
        transactionSubmitted ? buildProgressOverlay() : Container(),
      ],
    );
  }
}
