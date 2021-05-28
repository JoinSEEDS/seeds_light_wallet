import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/explore_screens/explore/components/explore_info_card.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/viewmodels/bloc.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc()..add(const LoadExploreData()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Explore', style: Theme.of(context).textTheme.headline6),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg'),
              onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
            ),
          ],
        ),
        body: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, ExploreState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ExploreInfoCard(
                        onTap: () async {
                          bool? res = await NavigationService.of(context).navigateTo(Routes.createInvite);
                          if (res != null && res) {
                            BlocProvider.of<ExploreBloc>(context)..add(const LoadExploreData());
                          }
                        },
                        title: 'Invite',
                        amount: state.availableSeeds?.roundedQuantity,
                        isErrorState: state.availableSeeds == null,
                        icon: SvgPicture.asset(
                          'assets/images/explore/person_send_invite.svg',
                          color: AppColors.white,
                        ),
                        amountLabel: 'Available Seeds',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              onTap: () async {
                                bool? res = await NavigationService.of(context).navigateTo(Routes.plantSeeds);
                                if (res != null && res) {
                                  BlocProvider.of<ExploreBloc>(context)..add(const LoadExploreData());
                                }
                              },
                              title: 'Plant',
                              amount: state.plantedSeeds?.roundedQuantity,
                              isErrorState: state.plantedSeeds == null,
                              icon: SvgPicture.asset('assets/images/explore/plant_seed.svg'),
                              amountLabel: 'Planted Seeds',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              onTap: () {},
                              title: 'Vote',
                              amount: 'TODO',
                              icon: SvgPicture.asset('assets/images/explore/thumb_up.svg'),
                              amountLabel: 'Trust Tokens',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ExploreInfoCard(
                              onTap: () {},
                              title: 'Get Seeds',
                              amount: 'TODO',
                              amountLabel: 'Seeds',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ExploreInfoCard(
                              onTap: () {},
                              title: 'Hypha DHO',
                              amount: 'TODO',
                              amountLabel: 'Hypha',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
