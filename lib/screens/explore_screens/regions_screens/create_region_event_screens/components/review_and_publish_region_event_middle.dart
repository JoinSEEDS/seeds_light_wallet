import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ReviewAndPublishRegionEventMiddle extends StatelessWidget {
  const ReviewAndPublishRegionEventMiddle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.eventName, style: Theme.of(context).textTheme.headline7),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.green1, size: 30),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start / ${state.startDateAndTimeFormatted}'),
                      Text('End / ${state.endDateAndTimeFormatted}')
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
