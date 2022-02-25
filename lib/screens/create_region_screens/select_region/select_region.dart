import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SelectRegion extends StatelessWidget {
  const SelectRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.createRegionSelectRegionAppBarTitle),
        ),
        bottomNavigationBar: SafeArea(
          child: FlatButtonLong(title: "${context.loc.createRegionSelectRegionButtonTitle} (1/5)", onPressed: () {}),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Text(context.loc.createRegionSelectRegionDescription),
            // TODO(gguij004): Waiting on map component.
          ],
        )));
  }
}
