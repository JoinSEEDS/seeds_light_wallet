import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/region_event_card.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionEvents extends StatelessWidget {
  const RegionEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RegionEventModel>>(
      stream: BlocProvider.of<RegionBloc>(context).regionEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<RegionEventModel> events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (_, index) => RegionEventCard(events[index]),
          );
        } else {
          return const FullPageLoadingIndicator();
        }
      },
    );
  }
}
