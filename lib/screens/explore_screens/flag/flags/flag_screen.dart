import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/account_action_row.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/flag/flags/components/remove_flag_info_dialog.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/viewmodels/flag_bloc.dart';

class FlagScreen extends StatelessWidget {
  const FlagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlagBloc()..add(const LoadUsersFlags()),
      child: BlocBuilder<FlagBloc, FlagState>(
        builder: (context, FlagState state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Flag')),
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: FlatButtonLong(
                title: 'Flag a User',
                onPressed: () async {
                  final shouldScreenReload =
                      await NavigationService.of(context).navigateTo(Routes.flagUser, state.usersIHaveFlagged);
                  if (shouldScreenReload != null) {
                    // ignore: use_build_context_synchronously
                    BlocProvider.of<FlagBloc>(context).add(const LoadUsersFlags());
                  }
                },
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<FlagBloc, FlagState>(
                builder: (context, state) {
                  switch (state.pageState) {
                    case PageState.initial:
                      return const SizedBox.shrink();
                    case PageState.loading:
                      return const FullPageLoadingIndicator();
                    case PageState.failure:
                      return const FullPageErrorIndicator();
                    case PageState.success:
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: state.usersIHaveFlagged.isEmpty
                            ? Center(
                                child: Text(
                                  'You have not flagged any users',
                                  style: Theme.of(context).textTheme.buttonLowEmphasis,
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.only(bottom: 80),
                                children: [
                                  for (final member in state.usersIHaveFlagged)
                                    AccountActionRow(
                                      image: member.image,
                                      account: member.account,
                                      nickname: member.nickname,
                                      action: TextButton(
                                        onPressed: () {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value: BlocProvider.of<FlagBloc>(context),
                                                child: RemoveFlagInfoDialog(member.account),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Remove Flag",
                                          style: TextStyle(color: AppColors.red, fontSize: 12),
                                        ),
                                      ),
                                      onTileTap: () {
                                        // No - Op for now.
                                      },
                                    )
                                ],
                              ),
                      );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
