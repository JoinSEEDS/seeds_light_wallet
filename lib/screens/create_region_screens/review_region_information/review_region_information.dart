import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/utils/build_context_extension.dart';

// TODO(gguij004): No UI for this page yet.

class ReviewRegion extends StatelessWidget {
  const ReviewRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.createRegionSelectRegionAppBarTitle),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: FlatButtonLong(title: "Create Region (5/5)", onPressed: () {}),
        ),
        body: SafeArea(minimum: const EdgeInsets.all(16), child: Column()));
  }
}
