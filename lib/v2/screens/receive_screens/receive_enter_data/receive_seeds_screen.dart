import 'package:flutter/material.dart';
import 'package:seeds/v2/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_light.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class ReceiveEnterDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Receive", style: Theme.of(context).textTheme.headline7),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  AmountEntryWidget(
                    onValueChange: (value) {
                      // BlocProvider.of<ReceiveEnterDataPageBloc>(context)
                      //     .add(OnAmountChange(amountChanged: value));
                    },
                    autoFocus: true,
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: Column(
                      children: [
                        TextFormFieldLight(
                          labelText: "Description",
                          hintText: "Enter Product Details",
                          maxLength: blockChainMaxChars,
                          onChanged: (String value) {
                            // BlocProvider.of<ReceiveEnterDataPageBloc>(context)
                            //     .add(OnDescriptionChange(descriptionChanged: value));
                          },
                        ),
                        const SizedBox(height: 16),
                        const BalanceRow(
                          label: "Available Balance",
                          fiatAmount: "TODO",
                          seedsAmount: "TODO",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButtonLong(
                  title: 'Next',
                  enabled: false,
                  onPressed: () {
                    // BlocProvider.of<ReceiveEnterDataPageBloc>(context).add(OnNextButtonTapped());
                  },
                ),
              ),
            )
          ],
        ));
  }
}
