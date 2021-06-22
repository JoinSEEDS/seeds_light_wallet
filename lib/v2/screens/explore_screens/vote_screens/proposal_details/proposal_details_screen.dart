import 'package:cached_network_image/cached_network_image.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/images/vote/votes_abstain_slash.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/i18n/proposals.i18n.dart';

class ProposalDetailsScreen extends StatelessWidget {
  final ProposalModel proposal;

  const ProposalDetailsScreen(this.proposal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: CachedNetworkImage(
                    imageUrl: proposal.image,
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
                      child: Text(proposal.campaignType, style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
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
                              Flexible(child: Text(proposal.title, style: Theme.of(context).textTheme.headline7))
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            proposal.summary,
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
                                              child: Text(proposal.creator, style: Theme.of(context).textTheme.button)),
                                          Text(proposal.createdAt, style: Theme.of(context).textTheme.subtitle3),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(children: [Text('TODO', style: Theme.of(context).textTheme.subtitle2)]),
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
                            'Recipient: %s '.i18n.fill(["${proposal.recipient}"]),
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Requested: %s SEEDS'.i18n.fill(['${proposal.quantity}']),
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Type: %s '
                                .i18n
                                .fill([proposal.campaignType == 'alliance' ? "Alliance".i18n : "Campaign".i18n]),
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: %s '.i18n.fill(["${proposal.status}"]),
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stage: %s '.i18n.fill(["${proposal.stage}"]),
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
                                  text: proposal.url,
                                  style:
                                      Theme.of(context).textTheme.subtitle3OpacityEmphasis.copyWith(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await launcher.canLaunch(proposal.url)) {
                                        await launcher.launch(proposal.url);
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
                            proposal.description,
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
                                    InkWell(
                                      borderRadius: BorderRadius.circular(32.5),
                                      onTap: () {},
                                      child: const CustomPaint(
                                        size: Size(65, 65),
                                        painter: VotesUpArrow(
                                          circleColor: AppColors.lightGreen6,
                                          arrowColor: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text('Yes', style: Theme.of(context).textTheme.button),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(32.5),
                                      onTap: () {},
                                      child: const CustomPaint(
                                        size: Size(65, 65),
                                        painter: VotesAbstainSlash(),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text('Abstain', style: Theme.of(context).textTheme.button),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(32.5),
                                      onTap: () {},
                                      child: const CustomPaint(
                                        size: Size(65, 65),
                                        painter: VotesDownArrow(
                                          circleColor: AppColors.darkGreen2,
                                          arrowColor: AppColors.white,
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
  }
}
