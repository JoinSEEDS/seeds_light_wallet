import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
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
              // TODO(gguij004): pending select date screens.
              Row(
                children: [
                  const Expanded(child: Text("TODO")),
                  Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.green1,
                          width: 2,
                        ),
                        //color: AppColors.green1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("TODO"))
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
