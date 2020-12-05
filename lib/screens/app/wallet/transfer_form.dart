import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

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
  bool showPageLoader = false;
  String transactionId = "";
  final _formKey = GlobalKey<FormState>();
  double seedsValue = 0;

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

    print("Seeds valu to send: "+seedsValue.toString());
    try {
      var response = await Provider.of<EosService>(context, listen: false).transferSeeds(
          beneficiary: widget.arguments.accountName,
          amount: seedsValue,
        );

      String trxid = response["transaction_id"];

      _statusNotifier.add(true);
      _messageNotifier.add("Transaction hash: %s".i18n.fill(["$trxid"]));
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
                      child: CachedNetworkImage(
                          imageUrl: widget.arguments.avatar, fit: BoxFit.cover),
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
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              widget.arguments.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Hero(
          tag: "account#${widget.arguments.fullName}",
          child: Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              widget.arguments.accountName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey),
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
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
                  AmountField(onChanged: (val) => {seedsValue = val}),
                  MainButton(
                    margin: EdgeInsets.only(top: 25),
                    title: 'Send'.i18n,
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

enum InputMode { fiat, seeds }

class AmountField extends StatefulWidget {
  const AmountField({Key key, this.onChanged}) : super(key: key);

  final Function onChanged;
  @override
  _AmountFieldState createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  final controller = TextEditingController(text: '');
  String inputString = "";
  double seedsValue = 0;
  double fiatValue = 0;
  InputMode inputMode = InputMode.seeds;

  @override
  Widget build(BuildContext context) {
    String balance = BalanceNotifier.of(context).balance.quantity;

    return Column(
      children: [
        Stack(alignment: Alignment.centerRight, children: [
          TextFormField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            controller: controller,
            autofocus: true,
            validator: (val) {
              String error;
              double availableBalance =
                  double.tryParse(balance.replaceFirst(' SEEDS', ''));
              double transferAmount = double.tryParse(val);

              if (transferAmount == 0.0) {
                error = "Transfer amount cannot be 0.".i18n;
              } else if (transferAmount == null || availableBalance == null) {
                error = "Transfer amount is not valid.".i18n;
              } else if (transferAmount > availableBalance) {
                error =
                    "Transfer amount cannot be greater than availabe balance."
                        .i18n;
              }
              return error;
            },
            onChanged: (value) {
              setState(() {
                this.inputString = value;
              });
              widget.onChanged(_getSeedsValue(value));
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.amberAccent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.redAccent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: OutlineButton(
              // shape: OutlineInputBorder( // TODO: needs design
              //     borderRadius: BorderRadius.circular(13),
              //     borderSide: BorderSide(color: AppColors.borderGrey)),
              onPressed: () {
                _toggleInput();
              },
              child: Text(
                inputMode == InputMode.seeds ? 'SEEDS' : SettingsNotifier.of(context).selectedFiatCurrency,
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            ),
          )
        ]),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                child: Consumer<RateNotifier>(
                  builder: (context, rateNotifier, child) {
                    return Text(
                      inputString == null
                          ? ""
                          : _getOtherString(),
                      style: TextStyle(color: Colors.blue),
                    );
                  },
                ))),
      ],
    );
  }

  String _getOtherString() {
    double fieldValue = inputString != null ? double.tryParse(inputString) : 0;
    if (fieldValue == null) {
      return "";
    } else if (fieldValue == 0) {
      return "0";
    }
    return RateNotifier.of(context).amountToString(
                              fieldValue,
                              SettingsNotifier.of(context).selectedFiatCurrency, 
                              asSeeds: inputMode == InputMode.fiat);
  }

  double _getSeedsValue(String value) {
    double fieldValue = value != null ? double.tryParse(value) : 0;
    if (fieldValue == null || fieldValue == 0) {
      return 0;
    } 
    if (inputMode == InputMode.seeds) {
      return fieldValue;
    } else {
      return RateNotifier.of(context).toSeeds(fieldValue, SettingsNotifier.of(context).selectedFiatCurrency);
    }
  }

  void _toggleInput() {
    setState(() {
      if (inputMode == InputMode.seeds) {
        inputMode = InputMode.fiat;
      } else {
        inputMode = InputMode.seeds;
      }
      widget.onChanged(_getSeedsValue(inputString));
    });
  }
}
