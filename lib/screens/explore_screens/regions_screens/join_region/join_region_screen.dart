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
              const Text('Search for your closest region by inputting your address or nearest city.'),
              const SizedBox(height: 20.0),
              SizedBox(height: MediaQuery.of(context).size.height / 3, child: const RegionsMap()),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(text: 'Select'),
                    TextSpan(
                        text: ' Create New ',
                        style: Theme.of(context).textTheme.buttonWhiteL.copyWith(color: AppColors.canopy)),
                    const TextSpan(
                        text:
                            'Select if you do not see your region and would like to start your own. Heads up, you’ll need 1,000 seeds to create a region!'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              FlatButtonLong(title: 'Create new', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
