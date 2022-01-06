import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/images/explore/exclamation_circle.dart';
import 'package:seeds/images/explore/invite_person.dart';
import 'package:seeds/images/explore/plant_seeds.dart';
import 'package:seeds/images/explore/vote.dart';
import 'package:seeds/images/explore/vouch.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/explore/components/explore_card.dart';
import 'package:seeds/screens/explore_screens/explore/components/explore_link_card.dart';
import 'package:seeds/screens/explore_screens/explore/components/flag_user_info_dialog.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreBloc(),
      child: BlocConsumer<ExploreBloc, ExploreState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<ExploreBloc>(context).add(const ClearExplorePageCommand());
          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).navigateTo(pageCommand.route);
          }
        },
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Explore'.i18n)),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Row(
                children: [
                  Expanded(
                    child: ExploreLinkCard(
                      backgroundImage: 'assets/images/explore/get_seeds_card.jpg',
                      onTap: () => launch('$urlBuySeeds${settingsStorage.accountName}', forceSafariVC: false),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.createInvite));
                        },
                        title: 'Invite a Friend'.i18n,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: CustomPaint(size: Size(40, 40), painter: InvitePerson()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.vouch));
                        },
                        title: 'Vouch'.i18n,
                        icon: const CustomPaint(size: Size(31, 41), painter: Vouch()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (_) {
                              return const FlagUserInfoDialog();
                            },
                          ).whenComplete(
                            () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Coming up! ".i18n), duration: const Duration(seconds: 1)),
                            ),
                          );
                        },
                        title: 'Flag'.i18n,
                        icon: const CustomPaint(size: Size(40, 40), painter: ExclamationCircle()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.vote));
                        },
                        title: 'Vote'.i18n,
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: CustomPaint(size: Size(40, 40), painter: Vote()),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.plantSeeds));
                        },
                        title: 'Plant Seeds'.i18n,
                        icon: const CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ExploreCard(
                        onTap: () {
                          BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.unPlantSeeds));
                        },
                        title: 'Unplant Seeds'.i18n,
                        icon: const CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 150),
              ],
            ),
          );
        },
      ),
    );
  }
}
