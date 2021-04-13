import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/utils/double_extension.dart';

enum InputMode { fiat, seeds }

class AmountField extends StatefulWidget {
  const AmountField(
      {Key key,
      this.onChanged,
      this.currentCurrency,
      this.fiatCurrency,
      this.initialValue,
      this.availableBalance,
      this.autoFocus,
      this.hintText})
      : super(key: key);

  final Function onChanged;
  final String availableBalance;
  final String currentCurrency;
  final String fiatCurrency;
  final double initialValue;
  final bool autoFocus;
  final String hintText;

  @override
  _AmountFieldState createState() => _AmountFieldState(
        currentCurrency == null || currentCurrency == SEEDS
            ? InputMode.seeds
            : InputMode.fiat,
        inputString: initialValue?.fiatFormatted ?? '',
      );
}

class _AmountFieldState extends State<AmountField> {
  String inputString;
  double seedsValue = 0;
  double fiatValue = 0;
  InputMode inputMode;

  String get _fiatCurrency =>
      widget.fiatCurrency ?? SettingsNotifier.of(context).selectedFiatCurrency;
  String get _selectedCurrency =>
      inputMode == InputMode.fiat ? _fiatCurrency : SEEDS;
  bool get autoFocus => widget.autoFocus ?? true;
  bool get validateBalance => widget.availableBalance != null;

  _AmountFieldState(this.inputMode, {this.inputString});

  @override
  Widget build(BuildContext context) {
    var fiat = _fiatCurrency;
    var width = MediaQuery.of(context).size.width - 76;

    return Column(
      children: [
        Stack(alignment: Alignment.topRight, children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            initialValue: inputString,
            autofocus: autoFocus,
            inputFormatters: [
              UserInputNumberFormatter(),
            ],
            validator: (val) {
              String error;

              var transferAmount = double.tryParse(val);
              if (transferAmount == null) {
                return 'Invalid Amount'.i18n;
              } if (transferAmount == 0.0) {
                error = 'Amount cannot be 0.'.i18n;
              } else if (transferAmount < 0.0) {
                error = 'Amount cannot be negative.'.i18n;
              } 

              if (validateBalance) {
                var availableBalance =
                    double.tryParse(widget.availableBalance.replaceFirst(' SEEDS', ''));

                if (availableBalance == null) {
                  //error = "No balance.".i18n; // allow try send if we can't fetch balance for whatever reason
                } else if (_getSeedsValue(val) > availableBalance) {
                  error =
                      'Amount cannot be greater than availabe balance.'.i18n;
                }
              }
              return error;
            },
            onChanged: (value) {
              setState(() {
                inputString = value;
              });
              widget.onChanged(_getSeedsValue(value), _getFieldValue(value),
                  _selectedCurrency);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.amberAccent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.redAccent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: OutlineButton(
              onPressed: () {
                _toggleInput();
              },
              child: Text(
                inputMode == InputMode.seeds ? 'SEEDS' : fiat,
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
          child: Consumer<RateNotifier>(
            builder: (context, rateNotifier, child) {
              var currencyText = inputString == null ? '' : _getOtherString();
              var availableText =(widget.availableBalance != null &&
                          widget.availableBalance != '') ? widget.availableBalance + ' ' + 'available'.i18n : '';
              var total = currencyText.length.toDouble() + availableText.length.toDouble();
              var leftRatio = total == 0 ? 1 : currencyText.length / total;
              var rightRatio = total == 0 ? 0 : availableText.length / total;
              
              return Row(
                children: [
                  SizedBox(
                    width: width * leftRatio,
                    child: Text(
                      currencyText,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Spacer(),
                  (availableText != '')
                      ? SizedBox(
                          width: width * rightRatio,
                          child: Text(
                            availableText,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      : Container()
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // shows the other currency below the input field - either fiat or Seeds.
  String _getOtherString() {
    var fieldValue = inputString != null ? double.tryParse(inputString) : 0;
    if (fieldValue == null) {
      return '';
    } else if (fieldValue == 0) {
      return '0';
    }
    return RateNotifier.of(context).amountToString(
        fieldValue, SettingsNotifier.of(context).selectedFiatCurrency,
        asSeeds: inputMode == InputMode.fiat);
  }

  double _getFieldValue(String value) {
    var fieldValue = value != null ? double.tryParse(value) : 0;
    if (fieldValue == null || fieldValue == 0) {
      return 0;
    }
    return fieldValue;
  }

  double _getSeedsValue(String value) {
    var fieldValue = value != null ? double.tryParse(value) : 0;
    if (fieldValue == null || fieldValue == 0) {
      return 0;
    }
    if (inputMode == InputMode.seeds) {
      return fieldValue;
    } else {
      return RateNotifier.of(context).toSeeds(
          fieldValue, SettingsNotifier.of(context).selectedFiatCurrency);
    }
  }

  void _toggleInput() {
    setState(() {
      if (inputMode == InputMode.seeds) {
        inputMode = InputMode.fiat;
      } else {
        inputMode = InputMode.seeds;
      }
      widget.onChanged(_getSeedsValue(inputString), _getFieldValue(inputString),
          _selectedCurrency);
    });
  }
}
