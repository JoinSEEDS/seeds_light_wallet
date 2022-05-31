import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/explore/components/flag_user_info_dialog.dart';
import 'package:seeds/screens/explore_screens/explore/explore_view.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_bloc.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_page_command.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/components/introducing_regions_dialog.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreBloc(),
      child: BlocListener<ExploreBloc, ExploreState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            BlocProvider.of<ExploreBloc>(context).add(const ClearExplorePageCommand());
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            } else if (pageCommand is NavigateToBuySeeds) {
              launchUrl(Uri.parse('$urlBuySeeds${settingsStorage.accountName}'));
            } else if (pageCommand is ShowUserFlagInformation) {
              showDialog<void>(
                context: context,
                builder: (_) => const FlagUserInfoDialog(),
              ).whenComplete(
                () => BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.flag)),
              );
            } else if (pageCommand is ShowIntroduceRegions) {
              const IntroducingRegionsDialog().show(context).then((isNextPressed) {
                if (isNextPressed ?? false) {
                  BlocProvider.of<ExploreBloc>(context).add(const OnExploreCardTapped(Routes.joinRegion));
                }
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(title: Text(context.loc.explorerAppBarTitle)),
            body: const ExploreView(),
          )),
    );
  }
}
