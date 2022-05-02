import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';

class EditRegionEventLocation extends StatelessWidget {
  const EditRegionEventLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as RegionEventModel?;

    return BlocProvider(
        create: (_) => EditRegionEventBloc(event!),
        child: BlocConsumer<EditRegionEventBloc, EditRegionEventState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
            }

            BlocProvider.of<EditRegionEventBloc>(context).add(const ClearEditRegionEventPageCommand());
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text("Edit Event")),
              bottomNavigationBar: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: FlatButtonLong(
                      isLoading: state.isSaveChangesButtonLoading,
                      enabled: state.isSaveChangesButtonEnable,
                      title: "Save Changes",
                      onPressed: () => BlocProvider.of<EditRegionEventBloc>(context).add(const OnSaveChangesTapped()))),
              body: SafeArea(
                minimum: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                        "Choose the location of your event. First input the address and then move the pin to the exact location to be even more precise!"),
                    const SizedBox(height: 20),
                    Expanded(
                      child: RegionsMap(
                        initialPlace: Place(
                          lat: state.event.eventLocation.latitude,
                          lng: state.event.eventLocation.longitude,
                          placeText: state.event.eventName,
                        ),
                        onPlaceChanged: (place) {
                          BlocProvider.of<EditRegionEventBloc>(context).add(OnUpdateMapLocation(place));
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
