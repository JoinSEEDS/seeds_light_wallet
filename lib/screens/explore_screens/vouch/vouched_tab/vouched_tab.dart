import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/member_info_row.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/components/not_qualified_to_vouch_dialog.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/components/vouch_success_dialog.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_bloc.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_page_commands.dart';

class VouchedTab extends StatelessWidget {
  const VouchedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => VouchedBloc()..add(const LoadUserVouchedList(false)),
        child: BlocConsumer<VouchedBloc, VouchedState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            if (pageCommand is ShowVouchForMemberSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  FocusScope.of(context).unfocus();
                  return const VouchSuccessDialog();
                },
              );
            } else if (pageCommand is ShowNotQualifiedToVouch) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const NotQualifiedToVouchDialog(),
              );
            }

            BlocProvider.of<VouchedBloc>(context).add(const ClearPageCommand());
          },
          builder: (context, VouchedState state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Scaffold(
                  bottomNavigationBar: SafeArea(
                    minimum: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: FlatButtonLong(
                      enabled: state.canVouch,
                      title: 'Vouch for a member',
                      onPressed: () async {
                        final bool? shouldScreenReload =
                            await NavigationService.of(context).navigateTo(Routes.vouchForAMember, state.vouched) as bool?;
                        if (shouldScreenReload != null) {
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<VouchedBloc>(context).add(LoadUserVouchedList(shouldScreenReload));
                        }
                      },
                    ),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: state.vouched.isEmpty
                          ? Center(
                              child: Text(
                                'You have not vouched for anyone yet',
                                style: Theme.of(context).textTheme.buttonLowEmphasis,
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.only(bottom: 80),
                              children: [for (final i in state.vouched) MemberInfoRow(i)],
                            ),
                    ),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ));
  }
}
