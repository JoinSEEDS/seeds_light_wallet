import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/broadcast_transaction_overlay.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/transaction_details.dart';

class CustomTransactionArguments {
  final String account;
  final String name;
  final Map<String, dynamic> data;

  CustomTransactionArguments({this.account, this.name, this.data});
}

class CustomTransaction extends StatefulWidget {
  final CustomTransactionArguments arguments;

  CustomTransaction(this.arguments);

  @override
  _CustomTransactionState createState() => _CustomTransactionState();
}

class _CustomTransactionState extends State<CustomTransaction> {
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
      String transactionId = await sendTransaction();

      _statusNotifier.add(true);
      _messageNotifier.add(transactionId);
    } catch (err) {
      _statusNotifier.add(false);
      _messageNotifier.add(err.toString());
    }
  }

  Widget buildProgressOverlay() {
    return BroadcastTransactionOverlay(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
      onClose: () {
        NavigationService.of(context).navigateTo(Routes.app, null, true);
      },
    );
  }

  Widget buildTransactionForm() {
    var name = widget.arguments.name;
    var account = widget.arguments.account;
    var data = widget.arguments.data;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            NavigationService.of(context).navigateTo(Routes.app);
          },
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
                image: SvgPicture.asset(
                  "icon",
                  color: Colors.black,
                ),
                title: name,
                beneficiary: account,
              ),
              SizedBox(height: 8),
              Column(
                children: <Widget>[
                  ...data.entries
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              e.key,
                              style: TextStyle(
                                fontFamily: "heebo",
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              e.value.toString(),
                              style: TextStyle(
                                fontFamily: "heebo",
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
              SizedBox(height: 8),
              MainButton(
                margin: EdgeInsets.only(top: 25),
                title: 'Sign & Broadcast',
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> sendTransaction() async {
    var name = widget.arguments.name;
    var account = widget.arguments.account;
    var data = widget.arguments.data;

    var response = await EosService.of(context, listen: false).sendTransaction(
      account: account,
      name: name,
      data: data,
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
