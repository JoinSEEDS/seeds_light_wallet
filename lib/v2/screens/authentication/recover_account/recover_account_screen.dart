import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/recover_account_bloc.dart';

class RecoverAccountScreen extends StatelessWidget {
  const RecoverAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RecoverAccountBloc(),
      child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [const Text("TODO: Recover Account UI")],
          )),
    );
  }
}
