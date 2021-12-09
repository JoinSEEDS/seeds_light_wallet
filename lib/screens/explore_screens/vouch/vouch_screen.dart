import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/components/delegator_row.dart';
import 'package:seeds/screens/explore_screens/vouch/interactor/viewmodels/vouch_bloc.dart';

class VouchScreen extends StatelessWidget {
  const VouchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VouchBloc()..add(const LoadUserVouchList()),
      child:  BlocBuilder<VouchBloc, VouchState>(
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
                        onPressed: () =>{},
                      ),
                    ),
                    appBar: AppBar(title: const Text("Vouch"),),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: state.vouchFor.isEmpty
                          ? Center(
                        child: Text(
                          'Currently no user vouch',
                          style: Theme.of(context).textTheme.buttonLowEmphasis,
                        ),
                      )
                          : ListView(
                        padding: const EdgeInsets.only(top: 10),
                        children: [for (final i in state.vouchFor) DelegatorRow(i)],
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
