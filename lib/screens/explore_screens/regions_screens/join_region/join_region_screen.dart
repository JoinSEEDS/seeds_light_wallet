import 'package:flutter/material.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/utils/build_context_extension.dart';

class JoinRegionScreen extends StatelessWidget {
  const JoinRegionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.joinRegionAppBarTitle)),
      body: const RegionsMap(),
    );
  }
}
