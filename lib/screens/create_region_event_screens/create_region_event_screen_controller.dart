import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/create_region_event_screens/add_region_event_description.dart';
import 'package:seeds/screens/create_region_event_screens/add_region_event_image.dart';
import 'package:seeds/screens/create_region_event_screens/add_region_event_name.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/create_region_event_screens/pick_region_event_location.dart';
import 'package:seeds/screens/create_region_event_screens/review_and_publish_region_event.dart';

class CreateRegionEventScreenController extends StatelessWidget {
  const CreateRegionEventScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateRegionEventBloc(),
      child: BlocConsumer<CreateRegionEventBloc, CreateRegionEventState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {},
        builder: (_, state) {
          final CreateRegionEventScreen createRegionEventScreen = state.createRegionEventScreen;
          switch (createRegionEventScreen) {
            case CreateRegionEventScreen.selectLocation:
              return const PickRegionEventLocation();
            case CreateRegionEventScreen.displayName:
              return const AddRegionEventName();
            case CreateRegionEventScreen.addDescription:
              return const AddRegionEventDescription();
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
