import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/i18n/settings.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/settings/components/settings_card.dart';
import 'package:seeds/v2/screens/profile_screens/settings/interactor/viewmodels/bloc.dart';

// TODO(raul): this is not a list in the ProfileModel should I create a getter that returns a combined skills and interest list of Strings ??
const List<String> skillsAndInterest = ['Weaver', 'Facilitador', 'SharingXP'];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'.i18n)),
      body: BlocProvider(
        create: (context) => SettingsBloc()..add(LoadProfile()),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    SettingsCard(
                      icon: Icons.person_outline,
                      title: 'Display Name'.i18n,
                      titleValue: state.profile.nickname,
                      descriptionText: 'Set your Display Name so that others can recognize your account.'.i18n,
                      onTap: () async {
                        var res = await NavigationService.of(context).navigateTo(
                          Routes.editName,
                          state.profile.nickname,
                        );
                        if (res != null) {
                          BlocProvider.of<SettingsBloc>(context).add(OnNameChanged(name: res as String));
                        }
                      },
                    ),
                    SettingsCard(
                      icon: Icons.location_on_outlined,
                      title: 'Bioregion'.i18n,
                      titleValue: 'Bali',
                      descriptionText: 'Join or create a bioregion to become active in your local community!'.i18n,
                    ),
                    SettingsCard(
                      icon: Icons.attach_money_sharp,
                      title: 'Currency'.i18n,
                      titleValue: 'USD',
                      descriptionText:
                          'Setting your local currency lets you easily switch between your local and preferred currency.'
                              .i18n,
                      onTap: () {
                        NavigationService.of(context).navigateTo(Routes.setCurrency);
                      },
                    ),
                    SettingsCard(
                      icon: Icons.favorite_border,
                      title: 'Skills & Interest'.i18n,
                      descriptionWidget: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 5, // gap between adjacent chips
                          runSpacing: 0, // gap between lines
                          children: skillsAndInterest
                              .map((i) => Chip(
                                    backgroundColor: AppColors.lightGreen2,
                                    label: Text(
                                      i,
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
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
