import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/components/delegate_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateScreen extends StatelessWidget {
  const DelegateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust & Delegates'),
      ),
      body: BlocProvider(
        create: (context) => DelegateBloc()..add(const LoadDelegateData()),
        child: BlocConsumer<DelegateBloc, DelegateState>(
          listener: (context, state) {},
          builder: (context, DelegateState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Column(
                  children: <Widget>[
                    DelegateCard(
                        onTap: () {
                          NavigationService.of(context).navigateTo(Routes.delegateAUser);
                        },
                        activeDelegate: state.activeDelegate,
                        delegate: state.delegate)
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
