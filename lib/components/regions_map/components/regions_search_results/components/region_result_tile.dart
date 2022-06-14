import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/viewmodels/regions_search_results_bloc.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/region_members.dart';
import 'package:seeds/navigation/navigation_service.dart';

class RegionResultTile extends StatelessWidget {
  final RegionModel region;

  const RegionResultTile(this.region, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        onTap: () => NavigationService.of(context).navigateTo(Routes.region, region),
        tileColor: AppColors.darkGreen2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        leading:
            region.imageUrl != null ? CircleAvatar(foregroundImage: NetworkImage(region.imageUrl!), radius: 23) : null,
        title: Text(
          region.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline7LowEmphasis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('${region.membersCount}', style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                const SizedBox(width: 4.0),
                const CustomPaint(size: Size(13, 13 * 0.92), painter: RegionMembers())
              ],
            ),
            BlocBuilder<RegionsSearchResultsBloc, RegionsSearchResultsState>(
              builder: (context, state) {
                return Text('${region.distanceTo(state.currentPlace!.lat, state.currentPlace!.lng).truncate()} km',
                    style: Theme.of(context).textTheme.subtitle2OpacityEmphasis);
              },
            ),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_sharp),
      ),
    );
  }
}
