import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/regions_map/regions_map.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/components/create_new_region_dialog.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/components/not_enough_seeds_dialog.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_page_command.dart';
import 'package:seeds/utils/build_context_extension.dart';

class JoinRegionScreen extends StatelessWidget {
  const JoinRegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JoinRegionBloc()..add(const OnJoinRegionMounted()),
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
            } else if (command is ShowCreateRegionInfo) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<JoinRegionBloc>(context),
                    child: const CreateNewRegionDialog(),
                  );
                },
              );
            } else if (command is ShowNotEnoughSeedsDialog) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return const NotEnoughSeedsDialog();
                },
              );
            } else if (command is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(command.message));
            }
          },
          buildWhen: (previous, current) => previous.pageState != current.pageState,
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
                        BlocBuilder<JoinRegionBloc, JoinRegionState>(
                          buildWhen: (previous, current) =>
                              previous.isRegionsResultsEmpty != current.isRegionsResultsEmpty,
                          builder: (context, state) {
                            return state.isRegionsResultsEmpty
                                ? Text(context.loc.joinRegionSearchDescription)
                                : const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                            child: RegionsMap(
                          showRegionsResults: true,
                          onRegionsChanged: (regions) {
                            BlocProvider.of<JoinRegionBloc>(context).add(OnRegionsResultsChanged(regions.isEmpty));
                          },
                        )),
                        BlocBuilder<JoinRegionBloc, JoinRegionState>(
                          buildWhen: (previous, current) =>
                              previous.isRegionsResultsEmpty != current.isRegionsResultsEmpty,
                          builder: (context, state) {
                            return state.isRegionsResultsEmpty
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: context.loc.joinRegionCreateDescription1),
                                        TextSpan(
                                            text: context.loc.joinRegionCreateDescription2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .buttonWhiteL
                                                .copyWith(color: AppColors.canopy)),
                                        TextSpan(text: context.loc.joinRegionCreateDescription3),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 20.0),
                        BlocBuilder<JoinRegionBloc, JoinRegionState>(
                          buildWhen: (previous, current) =>
                              previous.isCreateRegionButtonLoading != current.isCreateRegionButtonLoading,
                          builder: (context, state) {
                            return FlatButtonLong(
                                isLoading: state.isCreateRegionButtonLoading,
                                title: context.loc.joinRegionCreateDescription2,
                                onPressed: () =>
                                    BlocProvider.of<JoinRegionBloc>(context).add(const OnCreateRegionTapped()));
                          },
                        )
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
