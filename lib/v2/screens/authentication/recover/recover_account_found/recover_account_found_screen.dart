import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/recover_account_found_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

class RecoverAccountFoundScreen extends StatelessWidget {
  const RecoverAccountFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RecoverAccountFoundBloc(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<RecoverAccountFoundBloc, RecoverAccountFoundState>(
          builder: (context, state) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
