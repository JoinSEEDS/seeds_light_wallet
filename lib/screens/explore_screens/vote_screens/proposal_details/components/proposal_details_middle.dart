import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/selectable_text_with_links.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';
import 'package:seeds/utils/cap_utils.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ProposalDetailsMiddle extends StatelessWidget {
  const ProposalDetailsMiddle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
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
                  if (state.proposals[state.currentIndex].summary.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          state.proposals[state.currentIndex].summary,
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  Text('Created by'.i18n, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      ProfileAvatar(
                        size: 60,
                        image: state.creator!.image,
                        nickname: state.creator!.nickname,
                        account: state.creator!.account,
                      ),
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
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                  Text(
                                    state.proposals[state.currentIndex].createdAt,
                                    style: Theme.of(context).textTheme.subtitle3,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [Text(state.creator!.nickname, style: Theme.of(context).textTheme.titleSmall)],
                              ),
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
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.proposals[state.currentIndex].stage.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setting: %s '.i18n.fill([state.proposals[state.currentIndex].settingName]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'New Value: %s'.i18n.fill([state.proposals[state.currentIndex].settingValue]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                      ],
                    ),
                  if (state.proposals[state.currentIndex].stage.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recipient: %s '.i18n.fill([state.proposals[state.currentIndex].recipient]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Requested: %s '.i18n.fill([state.proposals[state.currentIndex].quantity]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type: %s '.i18n.fill([state.proposals[state.currentIndex].campaignType.i18n.inCaps]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: %s '.i18n.fill([state.proposals[state.currentIndex].status.inCaps]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stage: %s '.i18n.fill([state.proposals[state.currentIndex].stage.inCaps]),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        ),
                      ],
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
                              if (await launcher.canLaunchUrl(Uri.parse(state.proposals[state.currentIndex].url))) {
                                await launcher.launchUrl(Uri.parse(state.proposals[state.currentIndex].url));
                              } else {
                                // TODO(Raul): listener snack
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
                  SelectableTextWithLinks(
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
