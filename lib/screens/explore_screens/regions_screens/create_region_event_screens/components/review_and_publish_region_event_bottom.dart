import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ReviewAndPublishRegionEventBottom extends StatelessWidget {
  const ReviewAndPublishRegionEventBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Details", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  Flexible(child: Text(state.currentPlace!.placeText, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 16),
              Text(state.eventDescription, style: Theme.of(context).textTheme.subtitle2)
            ],
          ),
        );
      },
    );
  }
}
