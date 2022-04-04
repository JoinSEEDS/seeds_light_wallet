import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class PickRegionEventLocation extends StatelessWidget {
  const PickRegionEventLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Event")),
          bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: FlatButtonLong(
                  enabled: state.currentPlace != null,
                  title: "${context.loc.createRegionSelectRegionButtonTitle} (1/5)",
                  onPressed: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnNextTapped()))),
          body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                    "Choose the location of your event. First input the address and then move the pin to the exact location to be even more precise!"),
                const SizedBox(height: 20),
                Expanded(
                  child: RegionsMap(
                    onPlaceChanged: (place) {
                      BlocProvider.of<CreateRegionEventBloc>(context).add(OnUpdateMapLocation(place));
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
