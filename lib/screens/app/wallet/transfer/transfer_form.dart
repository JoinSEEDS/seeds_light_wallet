import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/widgets/amount_field.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/widgets/main_text_field.dart';

class TransferFormArguments {
  final String? fullName;
  final String? accountName;
  final String? avatar;

  TransferFormArguments(this.fullName, this.accountName, this.avatar);
}

class TransferForm extends StatefulWidget {
  final TransferFormArguments? arguments;

  const TransferForm(this.arguments);

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> with SingleTickerProviderStateMixin {
  bool showPageLoader = false;
  String transactionId = "";
  final _formKey = GlobalKey<FormState>();
  double seedsValue = 0;
  final TextEditingController memoController = TextEditingController();
  String memo = "";

  final StreamController<bool> _statusNotifier = StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
  }

  void processTransaction() async {
    setState(() {
      memo = memoController.text;
      showPageLoader = true;
    });

    print("Seeds valu to send: " + seedsValue.toString());
    try {
      var response = await Provider.of<EosService>(context, listen: false).transferSeeds(
        beneficiary: widget.arguments!.accountName,
        amount: seedsValue,
        memo: memo,
      );

      String? trxid = response["transaction_id"];

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
    if (_formKey.currentState!.validate()) {
      dismissKeyboard();
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
            child: widget.arguments!.avatar != null
                ? GestureDetector(
                    onTap: () => NavigationService.of(context).navigateTo(
                      Routes.imageViewer,
                      ImageViewerArguments(
                        imageUrl: widget.arguments!.avatar,
                        heroTag: "avatar#${widget.arguments!.accountName}",
                      ),
                    ),
                    child: Hero(
                      child: CachedNetworkImage(imageUrl: widget.arguments!.avatar!, fit: BoxFit.cover),
                      tag: "avatar#${widget.arguments!.accountName}",
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.arguments!.fullName!.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ),
        Hero(
          tag: "nickname#${widget.arguments!.fullName}",
          child: Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              widget.arguments!.fullName!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Hero(
          tag: "account#${widget.arguments!.fullName}",
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              widget.arguments!.accountName!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.grey),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BalanceModel? model = BalanceNotifier.of(context).balance;
    String? balance = model?.formattedQuantity;

    return GestureDetector(
      onTap: () {
        dismissKeyboard();
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarOpacity: 1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Container(
              margin: const EdgeInsets.only(left: 17, right: 17),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top + 22, width: 1),
                      buildProfile(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: AmountField(
                            availableBalance: balance,
                            onChanged: (seedsVal, fieldVal, currency) => {seedsValue = seedsVal}),
                      ),
                      MainTextField(
                          controller: memoController,
                          labelText: null,
                          autocorrect: false,
                          hintText: "Memo (optional)".i18n,
                          textStyle: const TextStyle(fontSize: 12)),
                      MainButton(
                        margin: const EdgeInsets.only(top: 20),
                        title: 'Send'.i18n,
                        onPressed: onSend,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          showPageLoader ? _buildPageLoader() : Container(),
        ],
      ),
    );
  }
}

extension DismissKeyboardState on State {
  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
