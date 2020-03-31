import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/providers/notifiers/telos_balance_notifier.dart';
import 'package:teloswallet/providers/services/eos_service.dart';
import 'package:teloswallet/widgets/fullscreen_loader.dart';
import 'package:teloswallet/widgets/main_button.dart';
import 'package:teloswallet/widgets/main_text_field.dart';

class TransferForm extends StatefulWidget {
  TransferForm();

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm>
    with SingleTickerProviderStateMixin {
  bool validAmount = true;
  bool showPageLoader = false;
  String transactionId = "";
  final _formKey = GlobalKey<FormState>();

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
  }

  void processTransaction() async {
    setState(() {
      showPageLoader = true;
    });

    try {
      var response =
          await Provider.of<EosService>(context, listen: false).transferTelos(
        beneficiary: beneficiaryController.text,
        amount: double.parse(amountController.text),
        memo: memoController.text,
      );

      String trxid = response["transaction_id"];

      _statusNotifier.add(true);
      _messageNotifier.add("Transaction hash: $trxid");
    } catch (err) {
      print(err);
      _statusNotifier.add(false);
      _messageNotifier.add(err.toString());
    }
  }

  Widget _buildPageLoader() {
    return FullscreenLoader(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
    );
  }

  final amountController = TextEditingController(text: '0.00');
  final beneficiaryController = TextEditingController(text: '');
  final memoController = TextEditingController(text: '');

  void onSend() {
    if (_formKey.currentState.validate()) {
      processTransaction();
    }
  }

  Widget buildProfile() {
    String name = beneficiaryController.text;

    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(width * 0.22),
          child: Container(
            width: width * 0.22,
            height: width * 0.22,
            color: AppColors.blue,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                name.length >= 2 ? name.substring(0, 2).toUpperCase() : name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Material(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBalance(balance) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        margin: EdgeInsets.only(bottom: 20, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.blue.withOpacity(0.3)),
        ),
        padding: EdgeInsets.all(7),
        child: Column(
          children: <Widget>[
            Text(
              'Available balance',
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
            Padding(padding: EdgeInsets.only(top: 3)),
            Text(
              '$balance',
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    String balance = TelosBalanceNotifier.of(context).balance.quantity;
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(left: 17, right: 17),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  buildProfile(),
                  buildBalance(balance),
                  MainTextField(
                      controller: beneficiaryController,
                      labelText: 'Beneficiary'),
                  MainTextField(
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    controller: amountController,
                    labelText: 'Transfer amount',
                    endText: 'TLOS',
                    validator: (val) {
                      String error;
                      double availableBalance =
                          double.tryParse(balance.replaceFirst(' TLOS', ''));
                      double transferAmount = double.tryParse(val);

                      if (transferAmount == 0.0) {
                        error = "Transfer amount cannot be 0.";
                      } else if (transferAmount == null ||
                          availableBalance == null) {
                        error = "Transfer amount is not valid.";
                      } else if (transferAmount > availableBalance) {
                        error =
                            "Transfer amount cannot be greater than availabe balance.";
                      }
                      return error;
                    },
                  ),
                  MainTextField(controller: memoController, labelText: 'Memo'),
                  MainButton(
                    margin: EdgeInsets.only(top: 25),
                    title: 'Send',
                    onPressed: onSend,
                  )
                ],
              ),
            ),
          ),
        ),
        showPageLoader ? _buildPageLoader() : Container(),
      ],
    );
  }
}
