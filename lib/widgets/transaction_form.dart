// @dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/widgets.i18n.dart';

enum TransactionType { seedsTransfer, telosTranfser }

class TransactionForm extends StatefulWidget {
  final Image image;
  final String beneficiary;
  final String title;
  final TransactionType type;
  final String balance;
  final String label;

  TransactionForm({
    this.image,
    this.beneficiary,
    this.title,
    this.type,
    this.balance,
    this.label,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
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

  final controller = TextEditingController(text: '0.00');

  void onSend() async {
    setState(() {
      transactionSubmitted = true;
    });

    var eos = Provider.of<EosService>(context, listen: false);

    try {
      var amount = double.parse(controller.text);

      var response;

      if (widget.type == TransactionType.seedsTransfer) {
        response = await eos.transferSeeds(
          beneficiary: widget.beneficiary,
          amount: amount,
          memo: '',
        );
      } else if (widget.type == TransactionType.telosTranfser) {
        response = await eos.transferTelos(
          beneficiary: widget.beneficiary,
          amount: amount,
          memo: '',
        );
      }

      String transactionId = response['transaction_id'];

      _statusNotifier.add(true);
      _messageNotifier.add('Transaction hash: %s'.i18n.fill(['$transactionId']));
    } catch (err) {
      print(err.toString());
      _statusNotifier.add(false);
      _messageNotifier.add(err.toString());
    }
  }

  Widget _buildProgressOverlay() {
    return FullscreenLoader(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
    );
  }

  Widget _buildTransactionForm() {
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
        child: Column(
          children: <Widget>[
            _buildSummary(),
            _buildInputField(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return MainTextField(
      keyboardType: TextInputType.number,
      controller: controller,
      labelText: 'Transfer amount'.i18n,
      endText: widget.type == TransactionType.seedsTransfer ? 'SEEDS' : 'TLOS',
    );
  }

  Widget _buildButton() {
    return MainButton(
      margin: EdgeInsets.only(top: 25),
      title: 'Send'.i18n,
      onPressed: onSend,
    );
  }

  Widget _buildSummary() {
    final width = MediaQuery.of(context).size.width;
    final balance = '5.0000 SEEDS';

    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(width * 0.22),
          child: Container(
            width: width * 0.22,
            height: width * 0.22,
            color: AppColors.blue,
            child: widget.image,
          ),
        ),
        Material(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Material(
          child: Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              widget.beneficiary,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey),
            ),
          ),
        ),
        Container(
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
                'Available balance'.i18n,
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
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildTransactionForm(),
        transactionSubmitted ? _buildProgressOverlay() : Container(),
      ],
    );
  }
}
