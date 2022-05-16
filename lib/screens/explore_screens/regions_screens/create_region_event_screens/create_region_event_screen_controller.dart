import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/add_region_event_description.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/add_region_event_image.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/add_region_event_name.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/chose_event_date_and_time.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/pick_region_event_location.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/review_and_publish_region_event.dart';

class CreateRegionEventScreenController extends StatelessWidget {
  const CreateRegionEventScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;
    return BlocProvider(
      create: (_) => CreateRegionEventBloc(region!),
      child: BlocConsumer<CreateRegionEventBloc, CreateRegionEventState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }

          BlocProvider.of<CreateRegionEventBloc>(context).add(const ClearCreateRegionEventPageCommand());
        },
        builder: (_, state) {
          final CreateRegionEventScreen createRegionEventScreen = state.createRegionEventScreen;
          switch (createRegionEventScreen) {
            case CreateRegionEventScreen.selectLocation:
              return const PickRegionEventLocation();
            case CreateRegionEventScreen.displayName:
              return const AddRegionEventName();
            case CreateRegionEventScreen.addDescription:
              return const AddRegionEventDescription();
            case CreateRegionEventScreen.choseDataAndTime:
              return const ChoseEventDateAndTime();
            case CreateRegionEventScreen.selectBackgroundImage:
              return const AddRegionEventImage();
            case CreateRegionEventScreen.reviewAndPublish:
              return const ReviewAndPublishRegionEvent();
          }
        },
      ),
    );
  }
}
