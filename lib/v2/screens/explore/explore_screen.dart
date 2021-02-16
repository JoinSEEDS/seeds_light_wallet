import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ExploreBloc, ExploreState>(
            builder: (context, ExploreState state) {
              switch (state.pageState) {
                case PageState.initial:
                  return Container();
                case PageState.loading:
                  return Container(child: Center(child: Text("Loading...", style: Theme.of(context).textTheme.headline3,)));
                case PageState.failure:
                  return Container(child: Center(child: Text("Error: " + state.errorMessage, style: Theme.of(context).textTheme.subtitle3)));
                case PageState.success:
                  return ListView(
                    children: <Widget>[
                      ExploreInfoCard(
                        callback: () {},
                        title: "Invite",
                        amount: state.availableSeeds,
                        icon: SvgPicture.asset(
                          "assets/images/explore/person_send_invite.svg",
                          color: AppColors.white,
                        ),
                        amountLabel: "Available Seeds",
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: "Plant",
                              amount: "245",
                              icon: SvgPicture.asset("assets/images/explore/plant_seed.svg"),
                              amountLabel: "Planted Seeds",
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: "Vote",
                              amount: "2",
                              icon: SvgPicture.asset("assets/images/explore/thumb_up.svg"),
                              amountLabel: "Trust Tokens",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: "Get Seeds",
                              amount: "15",
                              amountLabel: "Seeds",
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              callback: () {},
                              title: "Hypha DHO",
                              amount: "5",
                              amountLabel: "Hypha",
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
