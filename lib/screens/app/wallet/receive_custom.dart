import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/cart_model.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/receive.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';

class ReceiveCustom extends StatefulWidget {
  ReceiveCustom({Key key}) : super(key: key);

  @override
  _ReceiveCustomState createState() => _ReceiveCustomState();
}

class _ReceiveCustomState extends State<ReceiveCustom> {
  CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                EosService.of(context).accountName ?? '',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: ReceiveForm(cart, () => setState(() {})),
            ),
            
            ),
      ),
    );
  }

}

class ReceiveForm extends StatefulWidget {
  final CartModel cart;
  final Function onChange;

  ReceiveForm(this.cart, this.onChange);

  @override
  _ReceiveFormState createState() => _ReceiveFormState();
}

class _ReceiveFormState extends State<ReceiveForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');

  final products = List<ProductModel>();

  double receiveAmount = 0;

  _ReceiveFormState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }



  void generateInvoice(String amount) async {
    //double receiveAmount = double.tryParse(amount) ?? 0;

    setState(() {
      // invoiceAmountDouble = receiveAmount;
      // invoiceAmount = receiveAmount.toStringAsFixed(4);
    });
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
                buildEntryField(),
                MainButton(
                    title: "Next".i18n,
                    active: receiveAmount > 0,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      NavigationService.of(context)
                          .navigateTo(Routes.receiveQR, receiveAmount);
                    }),
          ],
        ),
      ),
    );
  }

  Widget buildEntryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [

        AmountField(onChanged: (val) => {receiveAmount = val}),

        // MainTextField(
        //   //focusNode: FocusNode(),
        //   keyboardType:
        //       TextInputType.numberWithOptions(signed: false, decimal: true),
        //   controller: controller,
        //   labelText: 'Receive (SEEDS)'.i18n,
        //   autofocus: false,
        //   inputFormatters: [
        //     UserInputNumberFormatter(),
        //   ],
        //   validator: (String amount) {
        //     String error;
        //     double receiveAmount;

        //     if (amount == null || amount == "") {
        //       return "Amount cannot be empty".i18n;
        //     }

        //     if (double.tryParse(amount) == null) {
        //       if (amount.isEmpty) {
        //         error = null;
        //       } else {
        //         error = "Receive amount is not valid".i18n;
        //       }
        //     } else {
        //       receiveAmount = double.parse(amount);

        //       if (amount == null || amount.isEmpty) {
        //         error = null;
        //       } else if (receiveAmount == 0.0) {
        //         error = "Amount cannot be 0.".i18n;
        //       } else if (receiveAmount < 0.0001) {
        //         error = "Amount must be > 0.0001".i18n;
        //       }
        //     }

        //     return error;
        //   },
        //   onChanged: (String amount) {
        //     if (formKey.currentState.validate()) {
        //       setState(() {
        //         receiveAmount = double.tryParse(amount);
        //       });
        //     } else {
        //       setState(() {
        //         receiveAmount = 0;
        //       });
        //     }
        //   },
        // ),
        // Align(
        //     alignment: Alignment.topLeft,
        //     child: Padding(
        //         padding: EdgeInsets.fromLTRB(16, 4, 0, 0),
        //         child: Consumer<RateNotifier>(
        //           builder: (context, rateNotifier, child) {
        //             return Text(
        //               rateNotifier.amountToString(receiveAmount,
        //                   SettingsNotifier.of(context).selectedFiatCurrency),
        //               style: TextStyle(color: Colors.blue),
        //             );
        //           },
        //         )))
      ]),
    );
  }
}

