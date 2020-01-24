import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/constants/custom_colors.dart';

class TransferAmount extends StatefulWidget {
  final String amountValue;

  TransferAmount(this.amountValue);

  @override
  _TransferAmountState createState() => _TransferAmountState();
}

class _TransferAmountState extends State<TransferAmount> {
  var amountController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 4);

  bool _buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    amountController.updateValue(double.parse(widget.amountValue));
  }

  _checkAmount(double amount) {
    if (amount > 0.0) {
      setState(() {
        _buttonEnabled = true;
      });
    } else {
      setState(() {
        _buttonEnabled = false;
      });
    }
  }

  _confirmAmount() {
    Navigator.of(context).pop(amountController.numberValue);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Enter amount",
            style: TextStyle(fontFamily: "worksans", color: Colors.black),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(CommunityMaterialIcons.close_circle,
                  color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop(amountController.numberValue);
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          'SEEDS',
                          style: TextStyle(fontFamily: "sfprotext"),
                        ),
                      ),
                      Spacer(flex: 1),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 3,
                        child: TextField(
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            showCursor: false,
                            autofocus: true,
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    top: 13, start: 25),
                                child: Text(
                                  '₴',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              prefixStyle: TextStyle(
                                  fontFamily: "vistolsans", fontSize: 25),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontFamily: "sfprotext",
                              color: Colors.black,
                              fontSize: 50,
                            ),
                            onChanged: (text) {
                              _checkAmount(double.parse(text));
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: FlatButton(
                      color: CustomColors.green,
                      textColor: CustomColors.green,
                      disabledColor: CustomColors.grey,
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: "worksans",
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: _buttonEnabled ? () => _confirmAmount() : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
