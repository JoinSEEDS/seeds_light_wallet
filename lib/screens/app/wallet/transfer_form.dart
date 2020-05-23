import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
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
          await Provider.of<EosService>(context, listen: false).transferSeeds(
        beneficiary: widget.arguments.accountName,
        amount: double.parse(controller.text),
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

  final controller = TextEditingController(text: '0.00');

  void onSend() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      processTransaction();
    }
  }

  Widget buildProfile() {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(width * 0.22),
          child: Container(
            width: width * 0.22,
            height: width * 0.22,
            color: AppColors.blue,
            child: widget.arguments.avatar != null
                ? GestureDetector(
                    onTap: () => NavigationService.of(context).navigateTo(
                      Routes.imageViewer,
                      ImageViewerArguments(
                        imageUrl: widget.arguments.avatar,
                        heroTag: "avatar#${widget.arguments.accountName}",
                      ),
                    ),
                    child: Hero(
                      child:
                          CachedNetworkImage(imageUrl: widget.arguments.avatar, fit: BoxFit.cover),
                      tag: "avatar#${widget.arguments.accountName}",
                    ),
                  )
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
    String balance = BalanceNotifier.of(context).balance.quantity;
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
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false, decimal: true),
                    controller: controller,
                    labelText: 'Transfer amount',
                    endText: 'SEEDS',
                    validator: (val) {
                      String error;
                      double availableBalance =
                          double.tryParse(balance.replaceFirst(' SEEDS', ''));
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
