import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seeds/customColors.dart';
import 'package:eosdart/eosdart.dart' as EOS;

import 'transferAmount.dart';

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
  String amountValue = '1.0000';
  bool validAmount = true;

  AnimationController animationController;

  bool showPageLoader = false;
  bool showSpinner = false;
  bool showChecked = false;
  String transactionId = "";

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        if (showSpinner) {
          animationController.reset();
        }
      } else if (animationController.status == AnimationStatus.dismissed) {
        if (showSpinner) {
          animationController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void _startTransaction() {
    setState(() {
      showPageLoader = true;
      showSpinner = true;
      animationController.forward();
    });
  }

  void _finishTransaction(trxId) {
    setState(() {
      showSpinner = false;
      showChecked = true;
      transactionId = trxId ?? "";
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        showChecked = false;
        showPageLoader = false;
      });
      Navigator.of(context).pop();
    });
  }

  _sendTransaction() async {
    String from = 'sevenflash32';
    String to = widget.accountName;
    String quantity = "$amountValue SEEDS";
    String memo = "";

    String privateKey = "";
    String endpointApi = "https://api.telos.eosindex.io";

    EOS.EOSClient client = EOS.EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

    Map data = {
      "from": from,
      "to": to,
      "quantity": quantity,
      "memo": memo,
    };

    List<EOS.Authorization> auth = [
      EOS.Authorization()
        ..actor = from
        ..permission = "active"
    ];

    List<EOS.Action> actions = [
      EOS.Action()
        ..account = 'token.seeds'
        ..name = 'transfer'
        ..authorization = auth
        ..data = data
    ];

    EOS.Transaction transaction = EOS.Transaction()..actions = actions;

    try {
      var response = await client.pushTransaction(transaction, broadcast: true);
      
      String transactionId = response["transaction_id"];

      return transactionId;
    } catch (e) {
      print("ERROR");
      print(e);

      return null;
    }
  }

  _onPressedSend() async {
    _startTransaction();

    String transactionId = await _sendTransaction();

    _finishTransaction(transactionId);
  }

  Widget _buildPageLoader() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        showSpinner
            ? Align(
                alignment: Alignment.center,
                child: RotationTransition(
                  child: Image.asset('assets/images/loading.png'),
                  turns:
                      Tween(begin: 0.0, end: 2.0).animate(animationController),
                ),
              )
            : Container(),
        showChecked
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/checked.png'),
                    SizedBox(
                      height: 25,
                    ),
                    Material(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Transaction Successful",
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 17,
                              color: CustomColors.Green,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            transactionId,
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 11,
                              color: CustomColors.Green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
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
                  //width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(widget.avatar),
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
                                        builder: (context) => TransferAmount(),
                                        fullscreenDialog: true,
                                      ),
                                    );

                                    setState(() {
                                      this.amountValue =
                                          navigationResult.toString();

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
                                // width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: FlatButton(
                                  color: CustomColors.Green,
                                  textColor: CustomColors.Green,
                                  disabledColor: CustomColors.Grey,
                                  child: Text(
                                    "Send Transaction",
                                    style: TextStyle(
                                      fontFamily: "worksans",
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  onPressed: () => _onPressedSend(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
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
