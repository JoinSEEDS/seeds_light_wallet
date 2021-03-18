import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/send_confirmation_bloc.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';

/// SendConfirmation SCREEN
class SendConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SendConfirmationBloc()..add(LoadSendConfirmation(userName: SettingsNotifier.of(context).accountName)),
      child: Scaffold(
        body: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
          builder: (context, SendConfirmationState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Container();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
