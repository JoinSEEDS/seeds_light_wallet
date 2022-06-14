import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/region_event_card.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionEvents extends StatelessWidget {
  const RegionEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.canCreateAnEvent
              ? FloatingActionButton(
                  backgroundColor: AppColors.green1,
                  onPressed: () => BlocProvider.of<RegionBloc>(context)..add(const OnAddEventButtonPressed()),
                  child: const Icon(Icons.add, color: AppColors.white),
                )
              : null,
          body: StreamBuilder<List<RegionEventModel>>(
            stream: BlocProvider.of<RegionBloc>(context).regionEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<RegionEventModel> events = snapshot.data!;
                events.sort((a, b) => a.eventStartTime.compareTo(b.eventStartTime));
                final upcomming = events.where((i) => DateTime.now().isBefore(i.eventStartTime.toDate())).toList();
                final expired = events.where((i) => DateTime.now().isAfter(i.eventStartTime.toDate())).toList();
                expired.sort((a, b) => b.eventStartTime.compareTo(a.eventStartTime));
                final all = [...upcomming, ...expired];
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: all.length,
                  itemBuilder: (_, index) => RegionEventCard(all[index]),
                );
              } else {
                return const FullPageLoadingIndicator();
              }
            },
          ),
        );
      },
    );
  }
}
