import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/images/vote/triangle_pass_value.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_time_icon.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProposalOpenCard extends StatelessWidget {
  final ProposalModel proposal;

  const ProposalOpenCard(this.proposal);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: proposal.hashCode,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 26.0),
        elevation: 8,
        child: InkWell(
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (proposal.image.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: proposal.image,
                    height: 150,
                    fit: BoxFit.fill,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomPaint(
                      painter: ProposalCategory(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(proposal.campaignType, style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: CustomPaint(size: const Size(28, 28), painter: VotesUpArrow()),
                              ),
                              Flexible(
                                  child: Text(
                                proposal.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline7,
                              )),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            proposal.summary,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: StepProgressIndicator(
                              totalSteps: proposal.total,
                              currentStep: proposal.favour,
                              size: 6,
                              padding: 0,
                              selectedColor: AppColors.green1,
                              unselectedColor: AppColors.lightGreen6,
                            ),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (_, constrains) {
                            // Percentage to advance 0-1 scale
                            var percent = ((proposal.voicePassed * 100) / proposal.total) / 100;
                            // If voice needed > total show 100% else show percent.
                            // triangle position - triangle middle width - left margin
                            var leftPadding = proposal.total < proposal.voicePassed
                                ? constrains.maxWidth - 6 - 16
                                : constrains.maxWidth * percent - 6 - 16;
                            return Padding(
                              padding: EdgeInsets.only(left: leftPadding, top: 20),
                              child: CustomPaint(size: const Size(12, 8), painter: TrianglePassValue()),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6.0),
                                      child: CustomPaint(size: const Size(20, 20), painter: VotesUpArrow()),
                                    ),
                                    Flexible(
                                      child: Text('In favour'.i18n + ': ${proposal.favourPercent}',
                                          style: Theme.of(context).textTheme.subtitle3Green),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text('Votes'.i18n + ': ${proposal.total}',
                                          style: Theme.of(context).textTheme.subtitle3Opacity),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6.0),
                                      child: CustomPaint(size: const Size(20, 20), painter: VotesDownArrow()),
                                    ),
                                    Flexible(
                                      child: Text('Against'.i18n + ': ${proposal.againstPercent}',
                                          style: Theme.of(context).textTheme.subtitle3LightGreen6),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CustomPaint(size: const Size(28, 28), painter: VotesTimeIcon()),
                              ),
                              Flexible(
                                child: Text(
                                  '${BlocProvider.of<VoteBloc>(context).state.currentRemainingTime?.days ?? 0} ' +
                                      'days left'.i18n,
                                  style: Theme.of(context).textTheme.headline7LowEmphasis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          FlatButtonLong(title: 'View Details and Vote'.i18n, enabled: true, onPressed: () {}),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
