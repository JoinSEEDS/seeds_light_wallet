import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/votes-to-string.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore/components/explore_info_card.dart';
import 'package:seeds/v2/screens/explore/interactor/explore_bloc.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_events.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc()..add(LoadExplore(userName: SettingsNotifier.of(context).accountName)),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, ExploreState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ExploreInfoCard(
                        callback: () {},
                        title: 'Invite',
                        amount: state.availableSeeds,
                        isErrorState: state.availableSeeds == null,
                        icon: SvgPicture.asset(
                          'assets/images/explore/person_send_invite.svg',
                          color: AppColors.white,
                        ),
                        amountLabel: 'Available Seeds',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: 'Plant',
                              amount: state.plantedSeeds,
                              isErrorState: state.plantedSeeds == null,
                              icon: SvgPicture.asset('assets/images/explore/plant_seed.svg'),
                              amountLabel: 'Planted Seeds',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: 'Vote',
                              amount: votesToSting(state.allianceVoice, state.campaignVoice),
                              icon: SvgPicture.asset('assets/images/explore/thumb_up.svg'),
                              amountLabel: 'Trust Tokens',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: 'Get Seeds',
                              amount: 'TODO',
                              amountLabel: 'Seeds',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: 'Hypha DHO',
                              amount: state.hyphaVoice,
                              amountLabel: 'Hypha',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
