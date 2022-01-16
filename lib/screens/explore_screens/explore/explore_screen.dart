import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/images/explore/exclamation_circle.dart';
import 'package:seeds/images/explore/invite_person.dart';
import 'package:seeds/images/explore/p2p.dart';
import 'package:seeds/images/explore/plant_seeds.dart';
import 'package:seeds/images/explore/seeds_symbol.dart';
import 'package:seeds/images/explore/vote.dart';
import 'package:seeds/images/explore/vouch.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/explore/components/explore_card.dart';
import 'package:seeds/screens/explore_screens/explore/components/flag_user_info_dialog.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_bloc.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_item.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_page_command.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreScreen extends StatelessWidget {
  final List<ExploreItem> _exploreItems = const [
    ExploreItem(
        title: 'Invite a Friend',
        icon: Padding(
            padding: EdgeInsets.only(left: 6.0), child: CustomPaint(size: Size(40, 40), painter: InvitePerson())),
        onTapEvent: OnExploreCardTapped(Routes.createInvite)),
    ExploreItem(
        title: 'Vouch',
        icon: CustomPaint(size: Size(35, 41), painter: Vouch()),
        onTapEvent: OnExploreCardTapped(Routes.vouch)),
    ExploreItem(
        title: 'Flag',
        icon: CustomPaint(size: Size(41, 41), painter: ExclamationCircle()),
        onTapEvent: OnFlagUserTap()),
    ExploreItem(
      title: 'Vote',
      icon: Padding(padding: EdgeInsets.only(right: 6.0), child: CustomPaint(size: Size(40, 40), painter: Vote())),
      onTapEvent: OnExploreCardTapped(Routes.vote),
    ),
    ExploreItem(
      title: 'Plant Seeds',
      icon: CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
      onTapEvent: OnExploreCardTapped(Routes.plantSeeds),
    ),
    ExploreItem(
      title: 'Unplant Seeds',
      icon: CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
      onTapEvent: OnExploreCardTapped(Routes.unPlantSeeds),
    ),
    ExploreItem(
      title: 'P2P app',
      icon: CustomPaint(size: Size(24, 24), painter: P2P()),
      iconUseCircleBackground: false,
      onTapEvent: OnExploreCardTapped(Routes.p2p),
    ),
    ExploreItem(
      title: 'Get Seeds',
      icon: CustomPaint(size: Size(9, 22), painter: SeedsSymbol()),
      backgroundIconColor: AppColors.white,
      gradient: LinearGradient(
        colors: [AppColors.green1, AppColors.darkGreen2],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      iconUseCircleBackground: false,
      onTapEvent: OnBuySeedsCardTap(),
    ),
  ];

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ExploreItem> items = _exploreItems;
    if (!remoteConfigurations.featureFlagP2PEnabled) {
      items = _exploreItems.where((i) => i.title != 'P2P app').toList();
    }
    return BlocProvider(
      create: (_) => ExploreBloc(),
      child: BlocConsumer<ExploreBloc, ExploreState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<ExploreBloc>(context).add(const ClearExplorePageCommand());
          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).navigateTo(pageCommand.route);
          } else if (pageCommand is NavigateToBuySeeds) {
            launch('$urlBuySeeds${settingsStorage.accountName}', forceSafariVC: false);
          } else if (pageCommand is ShowUserFlagInformation) {
            showDialog<void>(
              context: context,
              builder: (_) => const FlagUserInfoDialog(),
            ).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to flag page".i18n), duration: const Duration(seconds: 1)),
                ));
          }
        },
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Explore'.i18n)),
            body: GridView.count(
              padding: const EdgeInsets.all(18),
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              crossAxisCount: 2,
              children: [
                for (final i in items)
                  ExploreCard(
                    title: i.title.i18n,
                    icon: i.icon,
                    backgroundIconColor: i.backgroundIconColor,
                    iconUseCircleBackground: i.iconUseCircleBackground,
                    backgroundImage: i.backgroundImage,
                    gradient: i.gradient,
                    onTap: () => BlocProvider.of<ExploreBloc>(context).add(i.onTapEvent),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
