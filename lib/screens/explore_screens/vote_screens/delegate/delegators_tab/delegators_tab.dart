import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/components/delegator_row.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegators_bloc.dart';

class DelegatorsTab extends StatelessWidget {
  const DelegatorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegatorsBloc()..add(const OnLoadDelegatorsData()),
      child: BlocBuilder<DelegatorsBloc, DelegatorsState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'Delegators are Citizens that have chosen you to vote on their behalf. All votes already cast this cycle will not change.',
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                      Expanded(
                        child: state.delegators.isEmpty
                            ? Center(
                                child: Text(
                                  'Currently no delegators',
                                  style: Theme.of(context).textTheme.buttonLowEmphasis,
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.only(top: 10),
                                children: [for (final i in state.delegators) DelegatorRow(i)],
                              ),
                      ),
                    ],
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
