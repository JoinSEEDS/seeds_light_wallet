import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/shimmer_rectangle.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/citizenship_upgrade_button.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profileValuesArguments.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class CitizenshipCard extends StatelessWidget {
  const CitizenshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const ShimmerRectangle(size: Size(328, 145), radius: defaultCardBorderRadius);
            case PageState.success:
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen2,
                  borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 24.0),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(defaultCardBorderRadius),
                              ),
                              child: SvgPicture.asset(
                                "assets/images/profile/lotus.svg",
                                color: AppColors.canopy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'You are on the way from'.i18n,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Text(state.profile!.statusString,
                                          style: Theme.of(context).textTheme.headline6Green),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'to'.i18n,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline7
                                                  .copyWith(color: AppColors.primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                            state.profile!.status == ProfileStatus.visitor
                                                ? 'Resident'.i18n
                                                : 'Citizen'.i18n,
                                            style: Theme.of(context).textTheme.headline6Green),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      color: AppColors.green1,
                                      padding: const EdgeInsets.all(8.0),
                                      onPressed: () => NavigationService.of(context).navigateTo(
                                        Routes.citizenship,
                                        ProfileValuesArguments(
                                          profile: BlocProvider.of<ProfileBloc>(context).state.profile!,
                                        ),
                                      ),
                                      child: Text(
                                        'View your progress'.i18n,
                                        style: Theme.of(context).textTheme.subtitle3,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(width: 6)),
                                    CitizenshipUpgradeButton(
                                      citizenshipUpgradeStatus: state.citizenshipUpgradeStatus,
                                      onPressed: () {
                                        state.citizenshipUpgradeStatus == CitizenshipUpgradeStatus.canResident
                                            ? BlocProvider.of<ProfileBloc>(context)
                                                .add(const OnActivateResidentButtonTapped())
                                            : BlocProvider.of<ProfileBloc>(context)
                                                .add(const OnActivateCitizenButtonTapped());
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox(height: 145.0);
          }
        },
      ),
    );
  }
}
