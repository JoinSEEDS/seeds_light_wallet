import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teloswallet/generated/r.dart';
import 'package:teloswallet/providers/notifiers/resources_notifier.dart';
import 'package:teloswallet/providers/services/eos_service.dart';
import 'package:teloswallet/widgets/cpu_weight.dart';
import 'package:teloswallet/widgets/fullscreen_loader.dart';
import 'package:teloswallet/widgets/main_button.dart';
import 'package:teloswallet/widgets/main_text_field.dart';
import 'package:teloswallet/widgets/net_weight.dart';
import 'package:teloswallet/widgets/ram_bytes.dart';
import 'package:teloswallet/widgets/telos_balance.dart';
import 'package:teloswallet/widgets/transaction_details.dart';

class ManageResources extends StatefulWidget {
  ManageResources({Key key}) : super(key: key);

  @override
  _ManageResourcesState createState() => _ManageResourcesState();
}

class _ManageResourcesState extends State<ManageResources> {
  final buyRamController = TextEditingController(text: '1');
  final sellRamController = TextEditingController(text: '1');
  final delegateCpuController = TextEditingController(text: '1');
  final delegateNetController = TextEditingController(text: '1');
  final undelegateCpuController = TextEditingController(text: '1');
  final undelegateNetController = TextEditingController(text: '1');

  bool transactionSubmitted = false;

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();
  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ResourcesNotifier.of(context).fetchResources();
  }

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
      String transactionId;

      switch (currentTab) {
        case 0:
          transactionId = await buyRam();
          break;
        case 1:
          transactionId = await sellRam();
          break;
        case 2:
          transactionId = await delegateBw();
          break;
        case 3:
          transactionId = await undelegateBw();
          break;
      }

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

  int currentTab = 0;

  Widget buildTransactionForm() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
          padding: EdgeInsets.all(7),
          child: Column(
            children: [
              Container(
                height: 33,
                child: TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Buy'),
                      Tab(text: 'Sell'),
                      Tab(text: 'Delegate'),
                      Tab(text: 'Undelegate'),
                    ],
                    onTap: (index) {
                      currentTab = index;
                    }),
              ),
              Expanded(
                  child: TabBarView(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TransactionDetails(
                          image: SvgPicture.asset(R.buyram),
                          title: "Buy RAM",
                          beneficiary: "eosio.system",
                        ),
                        SizedBox(height: 8),
                        TelosBalance(),
                        RamBytes(),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: buyRamController,
                          labelText: 'Transfer amount',
                          endText: 'TLOS',
                        ),
                        MainButton(
                          margin: EdgeInsets.only(top: 25),
                          title: 'Buy RAM',
                          onPressed: onSubmit,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TransactionDetails(
                          image: SvgPicture.asset(R.sellram),
                          title: "Sell RAM",
                          beneficiary: "eosio.system",
                        ),
                        SizedBox(height: 8),
                        TelosBalance(),
                        RamBytes(),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: sellRamController,
                          labelText: 'RAM amount',
                          endText: 'Bytes',
                        ),
                        MainButton(
                          margin: EdgeInsets.only(top: 25),
                          title: 'Sell RAM',
                          onPressed: onSubmit,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TransactionDetails(
                          image: SvgPicture.asset(R.delegatebw),
                          title: "Delegate Bandwidth",
                          beneficiary: "eosio.system",
                        ),
                        SizedBox(height: 8),
                        TelosBalance(),
                        CpuWeight(),
                        NetWeight(),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: delegateCpuController,
                          labelText: 'CPU amount',
                          endText: 'TLOS',
                        ),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: delegateNetController,
                          labelText: 'NET amount',
                          endText: 'TLOS',
                        ),
                        MainButton(
                          margin: EdgeInsets.only(top: 25),
                          title: 'Delegate Bandwidth',
                          onPressed: onSubmit,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TransactionDetails(
                          image: SvgPicture.asset(R.undelegatebw),
                          title: "Undelegate Bandwidth",
                          beneficiary: "eosio.system",
                        ),
                        SizedBox(height: 8),
                        TelosBalance(),
                        CpuWeight(),
                        NetWeight(),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: undelegateCpuController,
                          labelText: 'CPU amount',
                          endText: 'TLOS',
                        ),
                        MainTextField(
                          keyboardType: TextInputType.number,
                          controller: undelegateNetController,
                          labelText: 'NET amount',
                          endText: 'TLOS',
                        ),
                        MainButton(
                          margin: EdgeInsets.only(top: 25),
                          title: 'Undelegate Bandwidth',
                          onPressed: onSubmit,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> buyRam() async {
    var response = await EosService.of(context, listen: false).buyRam(
      amount: double.parse(buyRamController.text),
    );
    return response["transaction_id"];
  }

  Future<String> sellRam() async {
    var response = await EosService.of(context, listen: false).sellRam(
      bytes: int.parse(sellRamController.text),
    );
    return response["transaction_id"];
  }

  Future<String> delegateBw() async {
    var response = await EosService.of(context, listen: false).delegateBw(
      amountCpu: double.parse(delegateCpuController.text),
      amountNet: double.parse(delegateNetController.text),
    );
    return response["transaction_id"];
  }

  Future<String> undelegateBw() async {
    var response = await EosService.of(context, listen: false).undelegateBw(
      amountCpu: double.parse(undelegateCpuController.text),
      amountNet: double.parse(undelegateNetController.text),
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
