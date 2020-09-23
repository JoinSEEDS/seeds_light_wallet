import 'package:flutter/material.dart' hide Action;
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class Receive extends StatefulWidget {
  Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');
  String invoiceAmount = '0.00 SEEDS';
  double invoiceAmountDouble = 0;

  void generateInvoice(String amount) async {
    double receiveAmount = double.parse(amount);

    setState(() {
      invoiceAmountDouble = receiveAmount;
      invoiceAmount = receiveAmount.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(EosService.of(context).accountName, style: TextStyle(color: Colors.black87),)
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              MainTextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: controller,
                labelText: 'Receive'.i18n,
                endText: 'SEEDS',
                autofocus: true,
                validator: (val) {
                  String error;

                  double receiveAmount = double.tryParse(val);

                  if (receiveAmount == 0.0) {
                    error = "Amount cannot be 0.".i18n;
                  } else if (receiveAmount < 0.0001) {
                    error = "Amount must be > 0.0001".i18n;
                  } else if (receiveAmount == null) {
                    error = "Receive amount is not valid".i18n;
                  }

                  return error;
                },
                onChanged: (val) {
                  if (formKey.currentState.validate()) {
                    generateInvoice(val);
                  } else {
                    setState(() {
                      invoiceAmountDouble = 0;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 33, 0, 0),
                child: MainButton(
                    title: "Next",
                    active: invoiceAmountDouble != 0,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      NavigationService.of(context).navigateTo(Routes.receiveQR, invoiceAmountDouble);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
