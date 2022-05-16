import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/user_input_number_formatter.dart';

class UnplantSeedsAmountEntry extends StatelessWidget {
  final TokenDataModel tokenDataModel;
  final FiatDataModel unplantedBalanceFiat;
  final ValueSetter<String> onValueChange;
  final GestureTapCallback onTapMax;
  final bool autoFocus;
  final TextEditingController? controller;

  const UnplantSeedsAmountEntry({
    super.key,
    required this.tokenDataModel,
    required this.onValueChange,
    required this.autoFocus,
    required this.onTapMax,
    required this.unplantedBalanceFiat,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.headline4,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "0.0",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                autofocus: autoFocus,
                onChanged: (String value) => onValueChange(value),
                inputFormatters: [
                  UserInputNumberFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [Text(tokenDataModel.symbol), const SizedBox(height: 18)],
                  ),
                  Positioned(
                    left: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        primary: AppColors.green1,
                      ),
                      onPressed: onTapMax,
                      child: const Text("MAX"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(unplantedBalanceFiat.asFormattedString()),
      ],
    );
  }
}
