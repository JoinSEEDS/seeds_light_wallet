import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ChooseRegionName extends StatelessWidget {
  const ChooseRegionName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.createRegionSelectRegionAppBarTitle),
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(horizontalEdgePadding),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormFieldCustom(
                      autofocus: true,
                      labelText: context.loc.createRegionChooseRegionNameInputFormTitle,
                    ),
                    const SizedBox(height: 20),
                    Text(context.loc.createRegionChooseRegionNameDescription,
                        style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButtonLong(
                      title: "${context.loc.createRegionSelectRegionButtonTitle} (2/5)", onPressed: () {}),
                ),
              ],
            )));
  }
}
