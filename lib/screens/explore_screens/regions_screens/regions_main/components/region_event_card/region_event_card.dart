import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/viewmodels/region_event_card_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/stacked_avatars.dart';
import 'package:seeds/utils/build_context_extension.dart';

class RegionEventCard extends StatelessWidget {
  final RegionEventModel event;

  const RegionEventCard(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegionEventCardBloc()..add(OnLoadRegionEventMembers(event.users)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.grey1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: event.eventImage,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width - 250,
                      width: MediaQuery.of(context).size.width - 32,
                      placeholder: (_, __) => const SizedBox.shrink(),
                      errorWidget: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.eventName,
                        style: Theme.of(context).textTheme.buttonLowEmphasis,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(DateFormat.yMMMMd().format(DateTime.parse(event.createdTime.toDate().toString()))),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      BlocBuilder<RegionEventCardBloc, RegionEventCardState>(
                        builder: (_, state) {
                          return state.profiles.isNotEmpty
                              ? StackedAvatars(state.profiles, 20)
                              : const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        '${context.loc.regionMainMembersTitle(event.users.length, event.readableMembersCount)} ${context.loc.regionEventCardJoinedTitle}',
                        style: Theme.of(context).textTheme.subtitle3.copyWith(color: AppColors.grey2),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.0),
                          border: Border.all(color: AppColors.green3),
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: AppColors.green3),
                            const SizedBox(width: 4.0),
                            Text(
                              '${event.formattedStartTime} - ${event.formattedEndTime}',
                              style: Theme.of(context).textTheme.subtitle3Green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
