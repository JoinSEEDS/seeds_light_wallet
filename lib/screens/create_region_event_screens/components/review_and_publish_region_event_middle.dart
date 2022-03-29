import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ReviewAndPublishRegionEventMiddle extends StatelessWidget {
  const ReviewAndPublishRegionEventMiddle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(DateFormat.yMMMMEEEEd().format(state.eventDateTime!))),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.green1,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: AppColors.green1),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat.jm().format(state.eventDateTime!),
                          style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Text(state.eventName)
            ],
          ),
        );
      },
    );
  }
}
