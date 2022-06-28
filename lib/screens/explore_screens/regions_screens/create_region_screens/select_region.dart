import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SelectRegion extends StatelessWidget {
  const SelectRegion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.createRegionSelectRegionAppBarTitle)),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(context.loc.createRegionSelectRegionDescription),
            const SizedBox(height: 20),
            Expanded(
              child: RegionsMap(onPlaceChanged: (place) {
                BlocProvider.of<CreateRegionBloc>(context).add(OnUpdateMapLocation(place));
              }),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocBuilder<CreateRegionBloc, CreateRegionState>(
          buildWhen: (previous, current) => previous.currentPlace != current.currentPlace,
          builder: (context, state) {
            return FlatButtonLong(
              enabled: state.currentPlace != null,
              title: "${context.loc.createRegionSelectRegionButtonTitle} (1/5)",
              onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped()),
            );
          },
        ),
      ),
    );
  }
}
