import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/images/vote/arrow_next_proposal.dart';
import 'package:seeds/v2/images/vote/arrow_previous_proposal.dart';
import 'package:seeds/v2/images/vote/votes_abstain_slash.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';

class ProposalDetailsScreen extends StatelessWidget {
  const ProposalDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProposalsAndIndex? proposalsAndIndex = ModalRoute.of(context)?.settings.arguments as ProposalsAndIndex?;
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProposalDetailsBloc(proposalsAndIndex!),
        child: BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (state.currentIndex != proposalsAndIndex!.index) {
                  Navigator.of(context).pop(state.currentIndex);
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 280,
                    flexibleSpace: Stack(
                      fit: StackFit.expand,
                      children: [
                        FittedBox(
                          fit: BoxFit.fill,
                          child: CachedNetworkImage(
                            imageUrl: state.proposals[state.currentIndex].image,
                            errorWidget: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        Positioned(
                          top: kToolbarHeight + 42,
                          left: 0,
                          child: CustomPaint(
                            size: const Size(82, 22),
                            painter: const ProposalCategory(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Text(state.proposals[state.currentIndex].campaignType,
                                  style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
                            ),
                          ),
                        ),
                        if (state.currentIndex > 0)
                          Positioned(
                            bottom: 24,
                            left: 24,
                            child: CustomPaint(
                              painter: const ArrowPreviousProposal(),
                              child: InkResponse(
                                onTap: () {
                                  BlocProvider.of<ProposalDetailsBloc>(context).add(const OnPreviousProposalTapped());
                                },
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        if (state.currentIndex < state.proposals.length - 1)
                          Positioned(
                            bottom: 24,
                            right: 24,
                            child: CustomPaint(
                              painter: const ArrowNextProposal(),
                              child: InkResponse(
                                onTap: () {
                                  BlocProvider.of<ProposalDetailsBloc>(context).add(const OnNextProposalTapped());
                                },
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(state.proposals[state.currentIndex].title,
                                              style: Theme.of(context).textTheme.headline7))
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    state.proposals[state.currentIndex].summary,
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 30.0),
                                  Text('Created by', style: Theme.of(context).textTheme.subtitle2),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const ProfileAvatar(size: 60, account: 'TODO'),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(state.proposals[state.currentIndex].creator,
                                                          style: Theme.of(context).textTheme.button)),
                                                  Text(state.proposals[state.currentIndex].createdAt,
                                                      style: Theme.of(context).textTheme.subtitle3),
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(children: [
                                                Text('TODO', style: Theme.of(context).textTheme.subtitle2)
                                              ]),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const DividerJungle(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recipient: %s '.i18n.fill(["${state.proposals[state.currentIndex].recipient}"]),
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Requested: %s '.i18n.fill(['${state.proposals[state.currentIndex].quantity}']),
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Type: %s '.i18n.fill([
                                      state.proposals[state.currentIndex].campaignType == 'alliance'
                                          ? "Alliance".i18n
                                          : "Campaign".i18n
                                    ]),
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Status: %s '.i18n.fill(["${state.proposals[state.currentIndex].status}"]),
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Stage: %s '.i18n.fill(["${state.proposals[state.currentIndex].stage}"]),
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'URL: '.i18n,
                                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                        ),
                                        TextSpan(
                                          text: state.proposals[state.currentIndex].url,
                                          style: Theme.of(context).textTheme.subtitle3LightGreen6,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (await launcher.canLaunch(state.proposals[state.currentIndex].url)) {
                                                await launcher.launch(state.proposals[state.currentIndex].url);
                                              } else {
                                                // todo listener snack
                                                // print("Couldn't open this url".i18n);
                                              }
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text('Description'.i18n, style: Theme.of(context).textTheme.headline7),
                                  const SizedBox(height: 8.0),
                                  SelectableText(
                                    state.proposals[state.currentIndex].description,
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                ],
                              ),
                            ),
                            const DividerJungle(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Precast your Vote'.i18n, style: Theme.of(context).textTheme.headline7),
                                  const SizedBox(height: 25.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CustomPaint(
                                              painter: const VotesUpArrow(
                                                circleColor: AppColors.lightGreen6,
                                                arrowColor: AppColors.white,
                                              ),
                                              child: InkResponse(
                                                onTap: () {},
                                                child: Container(
                                                  width: 65,
                                                  height: 65,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text('Yes', style: Theme.of(context).textTheme.button),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CustomPaint(
                                              painter: const VotesAbstainSlash(),
                                              child: InkResponse(
                                                onTap: () {},
                                                child: Container(
                                                  width: 65,
                                                  height: 65,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text('Abstain', style: Theme.of(context).textTheme.button),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CustomPaint(
                                              painter: const VotesDownArrow(
                                                circleColor: AppColors.darkGreen2,
                                                arrowColor: AppColors.white,
                                              ),
                                              child: InkResponse(
                                                onTap: () {},
                                                child: Container(
                                                  width: 65,
                                                  height: 65,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text('No', style: Theme.of(context).textTheme.button),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: FlatButtonLong(
                                      title: 'Confirm',
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
