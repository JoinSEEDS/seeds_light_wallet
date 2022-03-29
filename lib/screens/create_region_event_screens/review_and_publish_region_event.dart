import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/components/review_and_publish_region_event_bottom.dart';
import 'package:seeds/screens/create_region_event_screens/components/review_and_publish_region_event_header.dart';
import 'package:seeds/screens/create_region_event_screens/components/review_and_publish_region_event_middle.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ReviewAndPublishRegionEvent extends StatelessWidget {
  const ReviewAndPublishRegionEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            BlocProvider.of<CreateRegionEventBloc>(context).add(const OnBackPressed());
            return false;
          },
          child: Scaffold(
            appBar: AppBar(title: const Text("Create Event")),
            body: SafeArea(
              minimum: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const ReviewAndPublishRegionEventHeader(),
                        const ReviewAndPublishRegionEventMiddle(),
                        const DividerJungle(),
                        const ReviewAndPublishRegionEventBottom(),
                        const SizedBox(height: 60)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonLong(title: "Publish", onPressed: () => {}),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
