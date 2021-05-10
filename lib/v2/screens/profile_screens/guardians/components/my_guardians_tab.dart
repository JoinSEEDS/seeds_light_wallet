import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/guardians_bloc.dart';

class MyGuardiansTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
        stream: BlocProvider.of<GuardiansBloc>(context).guardians,
        builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
          if (snapshot.hasData) {
            // TODO(gguij002): Build this tab
            return const SizedBox.shrink();
          } else {
            // TODO(gguij002): Build this tab
            return const SizedBox.shrink();
          }
        });
  }
}
