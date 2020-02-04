import 'dart:async';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class TransferFormArguments {
  final String fullName;
  final String accountName;
  final String avatar;

  TransferFormArguments(this.fullName, this.accountName, this.avatar);
}

class TransferForm extends StatefulWidget {
  final TransferFormArguments arguments;

  TransferForm(this.arguments);

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm>
    with SingleTickerProviderStateMixin {
  double amountValue = 0;
  bool validAmount = true;

  bool showPageLoader = false;
  String transactionId = "";

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
      var response = await Provider.of<EosService>(context, listen: false)
          .transferSeeds(
              beneficiary: widget.arguments.accountName, amount: amountValue.toStringAsFixed(4));

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
      afterSuccessCallback: () {
        Navigator.of(context).pop();
      },
      afterFailureCallback: () {
        Navigator.of(context).pop();
      },
    );
  }

  final controller = TextEditingController(text: '0.00');

  void onSend() {
    processTransaction();
  }

  Widget buildProfile() {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(70),//width * 0.22),
          child: Container(
            width: 70,//width * 0.22,
            height: 70,//width * 0.22,
            color: AppColors.blue,
            child: widget.arguments.avatar != null
                ? Hero(
                    child:
                        CachedNetworkImage(imageUrl: widget.arguments.avatar),
                    tag: "avatar#${widget.arguments.accountName}")
                : Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.arguments.fullName.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ),
        Hero(
          tag: "nickname#${widget.arguments.fullName}",
          child: Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                widget.arguments.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Hero(
          tag: "account#${widget.arguments.fullName}",
          child: Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Text(
                widget.arguments.accountName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Stack(
        alignment: Alignment.centerRight,
        children:[
          TextFormField(
            autofocus: true,
            keyboardType: TextInputType.number,
            controller: controller,    
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              errorBorder: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue.withOpacity(0.5), width: 3)
              ),
              contentPadding: EdgeInsets.zero,
              focusedBorder:UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue, width: 3)
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(),
            child: Text('SEEDS',
              style: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 25
              ),
            ),
          ) 
        ]
      )
    );
  }

  Widget buildBalance() {
    final balance = BalanceNotifier.of(context).balance.quantity;

    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        margin: EdgeInsets.only(bottom: 20, top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGrey),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Your vailable balance',
              style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              '$balance',
              style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text('Transfer to',
              style: TextStyle(
                color: Colors.black
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 17, right: 17),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Column(
                      children: [
                        buildProfile(),
                        buildTextField(),
                        buildBalance(),
                      ]
                    )
                  ),
                  MainButton(
                    margin: EdgeInsets.only(bottom: 20, top: 15),
                    title: 'Send',
                    onPressed: onSend,
                  )
                ],
              ),
            ),
          )
        ),
        showPageLoader ? _buildPageLoader() : Container(),
      ],
    );
  }
}
