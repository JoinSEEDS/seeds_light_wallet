import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionMainAppBar extends StatelessWidget {
  const RegionMainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) {
        return SliverAppBar(
          expandedHeight: 200.0,
          pinned: true,
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
                      '${state.region?.readableMembersCount ?? 0} Members',
                      style: Theme.of(context).textTheme.buttonWhiteL,
                    ),
                  ],
                ),
              ),
              if (state.isBrowseView)
                Positioned(
                  right: 22,
                  bottom: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.green3),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(child: Text('Join', style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis)),
                  ),
                ),
            ],
          )),
        );
      },
    );
  }
}
