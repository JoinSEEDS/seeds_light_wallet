import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/user_input_number_formatter.dart';

class UnplantSeedsAmountEntry extends StatelessWidget {
  final TokenDataModel tokenDataModel;
  final ValueSetter<String> onValueChange;
  final bool autoFocus;

  const UnplantSeedsAmountEntry(
      {Key? key, required this.tokenDataModel, required this.onValueChange, required this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
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
                    onChanged: (String value) => {},
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
                        children: [
                          const Text("TODO"),
                          const SizedBox(height: 18)
                        ],
                      ),
                      Positioned(
                        left: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),primary: AppColors.green1),
                          onPressed: (){},
                          child: const Text("MAX"),
                          ),
                        ),

                    ],
                  ),
                ),
              ],
            ),
            const Text(
              "TODO"
            ),
          ],
        );

  }
}
