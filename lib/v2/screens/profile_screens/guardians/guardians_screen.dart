import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_events.dart';

/// GuardiansScreen SCREEN
class GuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuardiansBloc()..add(LoadGuardians(userName: SettingsNotifier.of(context).accountName)),
      child: const Scaffold(),
    );
  }
}
