import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/images/vote/triangle_pass_value.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProposalCard extends StatelessWidget {
  final ProposalModel proposal;

  const ProposalCard(this.proposal, {Key? key}) : super(key: key);

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
          onTap: () => NavigationService.of(context).navigateTo(Routes.proposalDetails, proposal),
          child: Ink(
            decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (proposal.image.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: proposal.image,
                          height: 150,
                          fit: BoxFit.fill,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomPaint(
                      painter: const ProposalCategory(),
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
                              const Padding(
                                padding: EdgeInsets.only(right: 6.0),
                                child: CustomPaint(
                                  size: Size(28, 28),
                                  painter: VotesUpArrow(
                                    circleColor: AppColors.lightGreen3,
                                    arrowColor: AppColors.green3,
                                  ),
                                ),
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
                    proposal.stage == 'staged'
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
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
                                        totalSteps: proposal.total > 1 ? proposal.total : 1,
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
                                      // If voice needed > total show 100% else show percent.
                                      // triangle position - triangle middle width - left margin
                                      var leftPadding = proposal.total < proposal.voiceNeeded
                                          ? constrains.maxWidth - 6 - 16
                                          : constrains.maxWidth * proposal.voiceNeededBarPercent - 6 - 16;
                                      return Padding(
                                        padding: EdgeInsets.only(left: leftPadding, top: 20),
                                        child: const CustomPaint(size: Size(12, 8), painter: TrianglePassValue()),
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
                                              const Padding(
                                                padding: EdgeInsets.only(right: 6.0),
                                                child: CustomPaint(
                                                  size: Size(20, 20),
                                                  painter: VotesUpArrow(
                                                    circleColor: AppColors.lightGreen3,
                                                    arrowColor: AppColors.green3,
                                                  ),
                                                ),
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
                                              const Padding(
                                                padding: EdgeInsets.only(right: 6.0),
                                                child: CustomPaint(
                                                  size: Size(20, 20),
                                                  painter: VotesDownArrow(
                                                    circleColor: AppColors.lightGreen3,
                                                    arrowColor: AppColors.lightGreen6,
                                                  ),
                                                ),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 26),
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
