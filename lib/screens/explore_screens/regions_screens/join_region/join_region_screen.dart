import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/components/region_result_tile.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class JoinRegionScreen extends StatelessWidget {
  const JoinRegionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JoinRegionBloc()..add(const OnLoadRegions()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: BlocBuilder<JoinRegionBloc, JoinRegionState>(
          builder: (context, state) {
            return Text(state.pageState == PageState.success ? context.loc.joinRegionAppBarTitle : '');
          },
        )),
        body: BlocConsumer<JoinRegionBloc, JoinRegionState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final command = state.pageCommand;
            if (command is NavigateToRoute) {
              NavigationService.of(context).navigateTo(command.route, null, true);
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.success:
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: Column(
                      children: [
                        if (state.regions.isEmpty) Text(context.loc.joinRegionSearchDescription),
                        const SizedBox(height: 20.0),
                        Expanded(
                            child: RegionsMap(
                          regions: state.regions,
                          onPlaceChanged: (place) {
                            BlocProvider.of<JoinRegionBloc>(context).add(OnUpdateMapLocation(place));
                          },
                          bottomWidget: state.currentPlace != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.regions.length,
                                  itemBuilder: (_, index) => RegionResultTile(state.regions[index]),
                                )
                              : null,
                        )),
                        if (state.regions.isEmpty)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: context.loc.joinRegionCreateDescription1),
                                TextSpan(
                                    text: context.loc.joinRegionCreateDescription2,
                                    style: Theme.of(context).textTheme.buttonWhiteL.copyWith(color: AppColors.canopy)),
                                TextSpan(text: context.loc.joinRegionCreateDescription3),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20.0),
                        FlatButtonLong(
                          title: context.loc.joinRegionCreateDescription2,
                          onPressed: () => NavigationService.of(context).navigateTo(Routes.createRegion),
                        ),
                      ],
                    ),
                  ),
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
