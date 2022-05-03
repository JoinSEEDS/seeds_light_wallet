import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/generic_region_dialog.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_bottom_sheet.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class RegionMainAppBar extends StatelessWidget {
  const RegionMainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) {
        return SliverAppBar(
          actions: [
            if (!state.isBrowseView)
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () => RegionBottomSheet(state.userType!).show(context),
              )
          ],
          expandedHeight: 220.0,
          flexibleSpace: FlexibleSpaceBar(
              background: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                state.region?.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.region?.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline7LowEmphasis,
                    ),
                    Text(
                      context.loc.regionMainMembersTitle(
                        state.region?.membersCount ?? 0,
                        '${state.region?.readableMembersCount ?? 0}',
                      ),
                      style: Theme.of(context).textTheme.buttonWhiteL,
                    ),
                  ],
                ),
              ),
              if (state.isBrowseView)
                Positioned(
                  right: 22,
                  bottom: 30,
                  child: InkWell(
                    onTap: () {
                      GenericRegionDialog(
                        title: context.loc.joinRegionConfirmDialogTitle,
                        description: context.loc.joinRegionConfirmDialogDescription,
                      ).show(context).then((isConfirmed) {
                        if (isConfirmed ?? false) {
                          BlocProvider.of<RegionBloc>(context).add(const OnJoinRegionButtonPressed());
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.green3),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                          child: Text(
                        context.loc.regionMainJoinTitle,
                        style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
                      )),
                    ),
                  ),
                ),
            ],
          )),
        );
      },
    );
  }
}
