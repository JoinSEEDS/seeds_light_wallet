import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/amount_field.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class ReceiveForm extends StatefulWidget {
  final Function onChange;

  const ReceiveForm(this.onChange);

  @override
  _ReceiveFormState createState() => _ReceiveFormState();
}

class _ReceiveFormState extends State<ReceiveForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');

  double receiveAmount = 0;

  _ReceiveFormState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            buildEntryField(),
            MainButton(
                title: 'Next'.i18n,
                active: receiveAmount > 0,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  NavigationService.of(context).navigateTo(Routes.receiveQR, receiveAmount);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildEntryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(children: [
        AmountField(
            onChanged: (val, fieldVal, currency) => {
                  setState(() {
                    receiveAmount = val;
                  })
                }),
      ]),
    );
  }
}
