import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_bloc.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_event.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_state.dart';

/// Explore SCREEN
class FlagScreen extends StatelessWidget {
  const FlagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlagBloc()..add(const LoadUsersFlags()),
      child: BlocConsumer<FlagBloc, FlagState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {},
        builder: (context, _) {
          return Scaffold(appBar: AppBar(title: Text('Flag'.i18n)), body: Container());
        },
      ),
    );
  }
}
