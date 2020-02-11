import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/available_balance.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/telos_balance.dart';
import 'package:seeds/widgets/transaction_details.dart';

class BuySeeds extends StatefulWidget {
  BuySeeds({Key key}) : super(key: key);

  @override
  _PlantSeedState createState() => _PlantSeedState();
}

class _PlantSeedState extends State<BuySeeds> {
  final plantController = TextEditingController(text: '1');

  bool transactionSubmitted = false;

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

  void onSubmit() async {
    setState(() {
      transactionSubmitted = true;
    });

    try {
      String transactionId = await buySeeds();

      _statusNotifier.add(true);
      _messageNotifier.add("Transaction hash: $transactionId");
    } catch (err) {
      _statusNotifier.add(false);
      _messageNotifier.add(err.toString());
    }
  }

  Widget buildProgressOverlay() {
    return FullscreenLoader(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
      successButtonText: "Success!",
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
                image: Image.asset("assets/images/explorer5.png"),
                title: "Buy Seeds",
                beneficiary: "tlosto.seeds",
              ),
              AvailableBalance(),
              TelosBalance(),
              MainTextField(
                keyboardType: TextInputType.number,
                controller: plantController,
                labelText: 'Transfer amount',
                endText: 'TLOS',
              ),
              MainButton(
                margin: EdgeInsets.only(top: 25),
                title: 'Buy Seeds',
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> buySeeds() async {
    var response = await EosService.of(context, listen: false).buySeeds(
      amount: double.parse(plantController.text),
    );
    return response["transaction_id"];
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
