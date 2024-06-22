import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class VotingCycleEndCard implements SliverPersistentHeaderDelegate {
  const VotingCycleEndCard();

  @override
  Widget build(BuildContext context, double shrinkOffSet, bool overLapsContent) {
    return BlocBuilder<VoteBloc, VoteState>(builder: (context, state) {
      final voteCycleEnded = state.voteCycleHasEnded;
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.primary),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16, bottom: 16, right: 14, left: 14),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(voteCycleEnded
                        ? context.loc.proposalVoteCycleEndedStatusMessage
                        : context.loc.proposalVoteCycleIsInProgressStatusMessage),
                    const SizedBox(height: 16.0),
                    Builder(
                      builder: (context) {
                        switch (state.pageState) {
                          case PageState.initial:
                            return const SizedBox.shrink();
                          case PageState.loading:
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [SizedBox(height: 20, width: 20, child: CircularProgressIndicator())],
                            );
                          case PageState.failure:
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(state.errorMessage!, style: Theme.of(context).textTheme.headlineSmall)],
                            );
                          case PageState.success:
                            return voteCycleEnded
                                ? Row(
                                    children: [
                                      Text(context.loc.proposalVoteCycleEndedTimeRemaining,
                                          style: Theme.of(context).textTheme.headlineSmall)
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('${state.currentRemainingTime?.days ?? 0} ',
                                              style: Theme.of(context).textTheme.headlineSmall),
                                          Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(context.loc.proposalVoteCycleIsInProgressTimeRemainingDays,
                                                  style: Theme.of(context).textTheme.subtitle3Opacity),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('${state.currentRemainingTime?.hours ?? 0} ',
                                              style: Theme.of(context).textTheme.headlineSmall),
                                          Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(context.loc.proposalVoteCycleIsInProgressTimeRemainingHours,
                                                  style: Theme.of(context).textTheme.subtitle3Opacity),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('${state.currentRemainingTime?.min ?? 0} ',
                                              style: Theme.of(context).textTheme.headlineSmall),
                                          Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(
                                                context.loc.proposalVoteCycleIsInProgressTimeRemainingMinutes,
                                                style: Theme.of(context).textTheme.subtitle3Opacity,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('${state.currentRemainingTime?.sec ?? 0} ',
                                              style: Theme.of(context).textTheme.headlineSmall),
                                          Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              Text(context.loc.proposalVoteCycleIsInProgressTimeRemainingSeconds,
                                                  style: Theme.of(context).textTheme.subtitle3Opacity),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  double get maxExtent => 130;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}
