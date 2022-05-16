import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/components/region_result_tile.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/viewmodels/page_commands.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/viewmodels/regions_search_results_bloc.dart';
import 'package:seeds/components/regions_map/interactor/view_models/page_commands.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class RegionsSearchResults extends StatelessWidget {
  final ValueSetter<List<RegionModel>>? onRegionsChanged;

  const RegionsSearchResults({super.key, this.onRegionsChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegionsSearchResultsBloc(BlocProvider.of<RegionsMapBloc>(context).state.regions)
        ..add(OnUpdateMapLocation(BlocProvider.of<RegionsMapBloc>(context).state.newPlace)),
      child: BlocListener<RegionsMapBloc, RegionsMapState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is MoveCameraStop) {
            BlocProvider.of<RegionsSearchResultsBloc>(context).add(OnUpdateMapLocation(state.newPlace));
          }
        },
        child: BlocConsumer<RegionsSearchResultsBloc, RegionsSearchResultsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final command = state.pageCommand;
            BlocProvider.of<RegionsSearchResultsBloc>(context).add(const ClearRegionsSearchResultsPageCommand());
            if (command is RegionsChanged) {
              onRegionsChanged?.call(state.nearbyRegions);
            }
            if (command is ShowErrorMessage) {
              eventBus.fire(const ShowSnackBar('Fail on retriving regions.'));
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.success:
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.nearbyRegions.length,
                  itemBuilder: (_, index) {
                    return RegionResultTile(state.nearbyRegions[index], key: Key(state.nearbyRegions[index].id));
                  },
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
