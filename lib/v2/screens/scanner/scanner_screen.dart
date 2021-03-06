import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/scanner/interactor/scanner_bloc.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_state.dart';

/// Scanner SCREEN
class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScannerBloc()..add(TodoNetworkCall(todoParamName: SettingsNotifier.of(context).accountName)),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, ScannerState state) {
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
