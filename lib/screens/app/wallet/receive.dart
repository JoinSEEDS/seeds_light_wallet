import 'package:flutter/material.dart' hide Action;
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Receive extends StatefulWidget {
  Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');
  String invoiceImage = '';
  String invoiceAmount = '0.00 SEEDS';

  void generateInvoice(String amount) async {
    double receiveAmount = double.parse(amount);

    var uri = await EosService.of(context, listen: false)
        .generateInvoice(receiveAmount);

    setState(() {
      invoiceAmount = receiveAmount.toStringAsFixed(4);
      invoiceImage = uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          key: formKey,
          child: Column(
            children: <Widget>[
              MainTextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: controller,
                labelText: 'Receive amount'.i18n,
                endText: 'SEEDS',
                autofocus: true,
                validator: (val) {
                  String error;

                  double receiveAmount = double.tryParse(val);

                  if (receiveAmount == 0.0) {
                    error = "Amount cannot be 0.".i18n;
                  } else if (receiveAmount == null) {
                    error = "Receive amount is not valid".i18n;
                  }

                  return error;
                },
                onChanged: (val) {
                  if (formKey.currentState.validate()) {
                    generateInvoice(val);
                  }
                },
              ),
              invoiceImage.isNotEmpty
                  ? Column(
                      children: [
                        QrImage(
                          data: invoiceImage,
                        ),
                        Text('Scan to transfer $invoiceAmount SEEDS'),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
