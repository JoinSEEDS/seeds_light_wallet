import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/domain-shared/user_input_decimal_precision.dart';
import 'package:seeds/v2/domain-shared/user_input_number_formatter.dart';

import 'interactor/amount_entry_bloc.dart';
import 'interactor/viewmodels/amount_entry_events.dart';
import 'interactor/viewmodels/amount_entry_state.dart';

class AmountEntryWidget extends StatelessWidget {
  final String? fiatAmount;
  final ValueSetter<String> onValueChange;
  final String enteringCurrencyName;
  final bool autoFocus;
  final int? decimalPrecision;

  const AmountEntryWidget({
    Key? key,
    this.fiatAmount,
    this.decimalPrecision,
    required this.onValueChange,
    required this.enteringCurrencyName,
    required this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
      create: (BuildContext context) => AmountEntryBloc(rates)..add(InitSendDataArguments()),
      child: BlocListener<AmountEntryBloc, AmountEntryState>(
        listenWhen: (previous, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.currentCurrencyInput == CurrencyInput.SEEDS) {
            onValueChange(state.textInput);
          } else {
            print("else:" + state.fiatToSeeds);
            onValueChange(state.fiatToSeeds.replaceAll(',', ""));
          }

          BlocProvider.of<AmountEntryBloc>(context).add(ClearPageCommand());
        },
        child: BlocBuilder<AmountEntryBloc, AmountEntryState>(
          builder: (BuildContext context, AmountEntryState state) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "0.0",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        autofocus: autoFocus,
                        onChanged: (String value) => BlocProvider.of<AmountEntryBloc>(context).add(OnAmountChange(
                          amountChanged: value,
                        )),
                        inputFormatters: [
                          UserInputNumberFormatter(),
                          DecimalTextInputFormatter(decimalRange: decimalPrecision ?? state.decimalPrecision)
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              Text(
                                state.currentCurrencyInput != CurrencyInput.FIAT
                                    ? enteringCurrencyName
                                    : settingsStorage.selectedFiatCurrency.toString(),
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              const SizedBox(height: 18)
                            ],
                          ),
                          Positioned(
                            bottom: -16,
                            left: 70,
                            child: Container(
                              height: 60,
                              width: 60,
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/currency_switch_button.svg',
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () =>
                                    {BlocProvider.of<AmountEntryBloc>(context).add(TabCurrencySwitchButton())},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  state.currentCurrencyInput == CurrencyInput.FIAT
                      ? state.fiatToSeeds + " " + currencySeedsCode
                      : "\$" + state.seedsToFiat + " " + settingsStorage.selectedFiatCurrency.toString(),
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
