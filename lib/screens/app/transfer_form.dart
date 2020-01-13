import 'dart:async';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/services/eos_service.dart';
import 'package:seeds/viewmodels/balance.dart';
import 'package:seeds/viewmodels/transactions.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/seeds_button.dart';

import 'transfer_amount.dart';

class TransferForm extends StatefulWidget {
  final String fullName;
  final String accountName;
  final String avatar;

  TransferForm(this.fullName, this.accountName, this.avatar);

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm>
    with SingleTickerProviderStateMixin {
      
  String amountValue = '0.0000';
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
      var response = await Provider.of<EosService>(context, listen: false).transferSeeds(widget.accountName, amountValue);

      String trxid = response["transaction_id"];

      // TransactionsModel transactions = Provider.of(context, listen: false).addTransaction();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        width: 150,
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  "Send to ${widget.accountName}",
                  style: TextStyle(fontFamily: "worksans", color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: CachedNetworkImageProvider(widget.avatar),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "${widget.fullName}",
                        style: TextStyle(
                            fontFamily: "worksans",
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: 25,
                        child: FlatButton(
                          color: CustomColors.Green,
                          textColor: Colors.white,
                          child: Text(
                            "${widget.accountName}",
                            style: TextStyle(
                              fontFamily: "worksans",
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "SEEDS",
                                  style: TextStyle(
                                    fontFamily: "worksans",
                                    fontSize: 12,
                                    color: CustomColors.Grey,
                                  ),
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  child: Text(
                                    this.amountValue,
                                    style: TextStyle(
                                        fontFamily: "worksans",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () async {
                                    var navigationResult = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TransferAmount(amountValue),
                                        fullscreenDialog: true,
                                      ),
                                    );

                                    setState(() {
                                      this.amountValue =
                                          navigationResult.toStringAsFixed(4);
                                      if (navigationResult.toString() !=
                                          '0.0') {
                                        this.validAmount = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(height: 0.1, color: CustomColors.Grey),
                            SizedBox(height: 30),
                            Opacity(
                              opacity: this.validAmount ? 1.0 : 0.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Add Memo',
                                    style: TextStyle(
                                      fontFamily: "worksans",
                                      fontSize: 17,
                                      color: CustomColors.Green,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: CustomColors.Grey,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1),
                            Opacity(
                              opacity: this.validAmount ? 1.0 : 0.0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: SeedsButton(
                                  "Send transaction",
                                  processTransaction,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            showPageLoader ? _buildPageLoader() : Container(),
          ],
        ),
      ),
    );
  }
}
