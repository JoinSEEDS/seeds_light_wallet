import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/i18n/proposals.i18n.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_time_icon.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';

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
        margin: const EdgeInsets.all(16),
        elevation: 8,
        child: InkWell(
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (proposal.image.isNotEmpty)
                  CachedNetworkImage(imageUrl: proposal.image, height: 150, fit: BoxFit.fill),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: CustomPaint(size: const Size(28, 28), painter: VotesUpArrow()),
                          ),
                          Flexible(child: Text(proposal.title, style: Theme.of(context).textTheme.headline7)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        proposal.summary,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                      ),
                      const SizedBox(height: 25.0),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 6,
                        animationDuration: 1,
                        percent: proposal.favourAgainstBarPercent,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: AppColors.lightGreen5,
                        progressColor: AppColors.green3,
                      ),
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
                                  child: Text('In favour: ' + proposal.favourPercent,
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
                                  child: Text('Votes: ' + proposal.total.toString(),
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
                                  child: Text('Against: ' + proposal.againstPercent,
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
                            child: Text('TODO days left', style: Theme.of(context).textTheme.headline7LowEmphasis),
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
          ),
        ),
      ),
    );
  }
}
