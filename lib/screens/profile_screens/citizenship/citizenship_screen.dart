import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart' show ProfileStatus;
import 'package:seeds/screens/profile_screens/citizenship/components/resident_view.dart';
import 'package:seeds/screens/profile_screens/citizenship/components/visitor_view.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_bloc.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profileValuesArguments.dart';

class CitizenshipScreen extends StatelessWidget {
  const CitizenshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileValuesArguments args = ModalRoute.of(context)!.settings.arguments! as ProfileValuesArguments;
    return BlocProvider(
      create: (_) => CitizenshipBloc()..add(SetValues(profile: args.profile)),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: args.profile.status == ProfileStatus.visitor ? const VisitorView() : const ResidentView(),
        ),
      ),
    );
  }
}
