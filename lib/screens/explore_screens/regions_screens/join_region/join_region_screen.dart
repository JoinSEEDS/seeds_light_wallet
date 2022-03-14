import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/build_context_extension.dart';

class JoinRegionScreen extends StatelessWidget {
  const JoinRegionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.loc.joinRegionAppBarTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
          child: Column(
            children: [
              Text(context.loc.joinRegionSearchDescription),
              const SizedBox(height: 20.0),
              const Expanded(child: RegionsMap()),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: context.loc.joinRegionCreateDescription1),
                    TextSpan(
                        text: context.loc.joinRegionCreateDescription2,
                        style: Theme.of(context).textTheme.buttonWhiteL.copyWith(color: AppColors.canopy)),
                    TextSpan(text: context.loc.joinRegionCreateDescription3),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              FlatButtonLong(title: context.loc.joinRegionCreateDescription2, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
