import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/Currencies.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';
import 'package:seeds/widgets/main_text_field.dart';

class AmountField extends StatefulWidget {
  const AmountField({Key key, this.onChanged, this.priceController, this.currentCurrency}) : super(key: key);

  final TextEditingController priceController;
  final Function onChanged;
  final Currency currentCurrency;

  @override
  _AmountFieldState createState() =>
      _AmountFieldState(double.tryParse(priceController.text), currentCurrency);
}

class _AmountFieldState extends State<AmountField> {
  _AmountFieldState(this.price, this.currentCurrency);

  bool validate = false;
  double price;
  Currency currentCurrency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainTextField(
          labelText: 'Price'.i18n,
          suffixIcon: Container(
            height: 35,
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
            child: OutlineButton(
              onPressed: () {
                _toggleInput();
              },
              child: Text(
                currentCurrency == Currency.SEEDS? 'SEEDS' : SettingsNotifier.of(context).selectedFiatCurrency,
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            ),
          ),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          controller: widget.priceController,
          autofocus: true,
          inputFormatters: [
            UserInputNumberFormatter(),
          ],
          validator: (String amount) {
            String error;

            double receiveAmount = double.tryParse(amount);

            if (amount == null) {
              error = null;
            } else if (amount.isEmpty) {
              error = 'Price field is empty'.i18n;
            } else if (receiveAmount == null) {
              error = 'Price needs to be a number'.i18n;
            }

            return error;
          },
          onChanged: (amount) {
            if (double.tryParse(amount) != null) {
              setState(() {
                price = double.tryParse(amount);
                validate = true;
              });
              widget.onChanged(price, currentCurrency, validate);
            } else {
              setState(() {
                price = 0;
                validate = true;
              });
              widget.onChanged(0, currentCurrency, validate);
            }
          },
        ),
      ],
    );
  }

  void _toggleInput() {
    setState(() {

      if (currentCurrency == Currency.SEEDS) {
        currentCurrency = Currency.FIAT;
        validate = false;
        widget.onChanged(price, currentCurrency, validate);
      } else {
        currentCurrency = Currency.SEEDS;
        validate = false;
        widget.onChanged(price, currentCurrency, validate);
      }
    });
  }
}
