import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/components/delegators_list_view.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_state.dart';

class DelegatorsTab extends StatelessWidget {
  const DelegatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegatorBloc()..add(const LoadDelegatorData()),
      child: BlocBuilder<DelegatorBloc, DelegatorState>(builder: (context, state) {
        switch (state.pageState) {
          case PageState.initial:
            return const SizedBox.shrink();
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
                    if (state.hasDelegators) Expanded(child: DelegatorsListWidget(delegators: state.delegators!)),
                  ],
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
