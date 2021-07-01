import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter/gestures.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';

class ProposalDetailsMiddle extends StatelessWidget {
  const ProposalDetailsMiddle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          state.proposals[state.currentIndex].title,
                          style: Theme.of(context).textTheme.headline7,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    state.proposals[state.currentIndex].summary,
                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                  ),
                  const SizedBox(height: 30.0),
                  Text('Created by'.i18n, style: Theme.of(context).textTheme.subtitle2),
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
                                    child: Text(
                                      state.proposals[state.currentIndex].creator,
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                  Text(
                                    state.proposals[state.currentIndex].createdAt,
                                    style: Theme.of(context).textTheme.subtitle3,
                                  ),
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
                      state.proposals[state.currentIndex].campaignType == 'alliance' ? "Alliance".i18n : "Campaign".i18n
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
          ],
        );
      },
    );
  }
}
