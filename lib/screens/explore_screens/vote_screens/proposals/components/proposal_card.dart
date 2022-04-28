import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/vote/category_label.dart';
import 'package:seeds/images/vote/double_sided_arrow.dart';
import 'package:seeds/images/vote/triangle_pass_value.dart';
import 'package:seeds/images/vote/votes_down_arrow.dart';
import 'package:seeds/images/vote/votes_up_arrow.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/vote_amount_label.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/proposals_localized.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:seeds/utils/cap_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProposalCard extends StatefulWidget {
  final ProposalViewModel proposal;
  final VoidCallback onTap;

  const ProposalCard({Key? key, required this.proposal, required this.onTap}) : super(key: key);

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    super.build(context);
    return Hero(
      tag: widget.proposal.hashCode,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 26.0),
            elevation: 8,
            child: InkWell(
              onTap: widget.onTap,
              child: Ink(
                decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.proposal.image.isNotEmpty)
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.proposal.image,
                        height: width - 100,
                        width: width - 32,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    const SizedBox(height: 20),
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
                                    child: CustomPaint(
                                      size: const Size(28, 28),
                                      painter: widget.proposal.stage == 'staged'
                                          ? const DoubleSidedArrow()
                                          : const VotesUpArrow(
                                              circleColor: AppColors.lightGreen3,
                                              arrowColor: AppColors.green3,
                                            ),
                                    ),
                                  ),
                                  Flexible(
                                      child: Text(
                                    widget.proposal.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.headline7,
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (widget.proposal.stage == 'staged')
                          const SizedBox.shrink()
                        else
                          Column(
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
                                        totalSteps: widget.proposal.total > 1 ? widget.proposal.total : 1,
                                        currentStep: widget.proposal.favour,
                                        size: 6,
                                        padding: 0,
                                        selectedColor: AppColors.green1,
                                        unselectedColor: AppColors.lightGreen6,
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (_, constrains) {
                                      // leftPadding = unity triangle position - triangle middle width - left margin
                                      final leftPadding = constrains.maxWidth * unityThreshold - 6 - 16;
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
                                                child: Text(
                                                    context.loc
                                                        .proposalVotesInFavourPercent(widget.proposal.favourPercent),
                                                    style: Theme.of(context).textTheme.subtitle3Green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(context.loc.proposalVotesTotal(widget.proposal.total),
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
                                                child: Text(
                                                    context.loc
                                                        .proposalVotesAgainstPercent(widget.proposal.againstPercent),
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
          Positioned(
            top: width / 2,
            left: 16,
            child: Row(
              children: [
                CustomPaint(
                  painter: const CategoryLabel(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: Text(widget.proposal.proposalCategory.localizedDescription(context).inCaps,
                        style: Theme.of(context).textTheme.subtitle2),
                  ),
                ),
              ],
            ),
          ),
          if (widget.proposal.stage != 'staged')
            Positioned(top: 10.0, right: 26.0, child: VoteAmountLabel(widget.proposal)),
          if (widget.proposal.stage == 'done' || widget.proposal.stage.isEmpty)
            Positioned(
              top: 10.0,
              left: 26.0,
              child: Container(
                decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(6.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    widget.proposal.localizedStatus(context).toUpperCase(),
                    style: widget.proposal.status == 'rejected'
                        ? Theme.of(context).textTheme.subtitle3OpacityEmphasisRed
                        : Theme.of(context).textTheme.subtitle3OpacityEmphasisGreen,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
