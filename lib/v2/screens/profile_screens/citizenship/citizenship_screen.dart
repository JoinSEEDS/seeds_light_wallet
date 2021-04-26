import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/components/resident_view.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/components/visitor_view.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profileValuesArguments.dart';

/// CITIZENSHIP SCREEN
class CitizenshipScreen extends StatelessWidget {
  const CitizenshipScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProfileValuesArguments args = ModalRoute.of(context)!.settings.arguments! as ProfileValuesArguments;
    return BlocProvider(
      create: (context) => CitizenshipBloc()..add(SetValues(profile: args.profile, score: args.scores)),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<CitizenshipBloc, CitizenshipState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return state.profile?.status == 'visitor' ? const VisitorView() : const ResidentView();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
