import 'dart:async';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/invoice_list_view.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/utils/double_extension.dart';

class InvoiceConfirmation extends StatefulWidget {
  final InvoiceModel invoice;

  InvoiceConfirmation({Key key, @required this.invoice}) : super(key: key);

  @override
  _InvoiceConfirmationState createState() => _InvoiceConfirmationState();
}

class _InvoiceConfirmationState extends State<InvoiceConfirmation> {
  bool showPageLoader = false;

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Invoice'.i18n,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: MainButton(
                title: "Pay".i18n,
                onPressed: () {
                  print("Pay!");
                  processTransaction();
                }),
          ),
          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: InvoiceListView(
                      invoice: widget.invoice,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        showPageLoader ? _buildPageLoader() : Container(),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    var text = "Send %s to %s?".i18n.fill(["${widget.invoice.doubleAmount.seedsFormatted}", "${widget.invoice.recipient}"]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Transfer"),
          content: Text(text),
          actions: [
            FlatButton(
              child: Text("Cancel".i18n),
              onPressed: () {},
            ),
            FlatButton(
              child: Text("Ok".i18n),
              onPressed: processTransaction,
            ),
          ],
        );
        ;
      },
    );
  }

  void processTransaction() async {
    setState(() {
      showPageLoader = true;
    });

    print("Seeds valu to send: " + widget.invoice.doubleAmount.toString());

    setState(() {
      showPageLoader = false;
    });

    return;

    try {
      var response =
          await Provider.of<EosService>(context, listen: false).transferSeeds(
        beneficiary: widget.invoice.recipient,
        amount: 0.0001, // widget.invoice.doubleAmount,
        memo: widget.invoice.memo,
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
}
