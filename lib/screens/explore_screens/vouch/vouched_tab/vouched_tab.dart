import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/member_info_row.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab//interactor/viewmodels/vouched_bloc.dart';

class VouchedTab extends StatelessWidget {
  const VouchedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VouchedBloc()..add(const LoadUserVouchedList()),
      child: BlocBuilder<VouchedBloc, VouchedState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return SafeArea(
                child: Scaffold(
                  bottomSheet: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlatButtonLong(
                      title: 'Vouch for a member',
                      onPressed: () => {},
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: state.vouched.isEmpty
                        ? Center(
                            child: Text(
                              'You have not vouched for anyone yet',
                              style: Theme.of(context).textTheme.buttonLowEmphasis,
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.only(top: 10),
                            children: [for (final i in state.vouched) MemberInfoRow(i)],
                          ),
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
