import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_bloc.dart';

class SelectedGuardiansWidget extends StatelessWidget {
  const SelectedGuardiansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectGuardiansBloc, SelectGuardiansState>(
      builder: (context, state) {
        return Wrap(
          children: state.selectedGuardians
              .toList()
              .reversed
              .map((user) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ActionChip(
                      label: Text(user.nickname.isEmpty ? user.account : user.nickname),
                      avatar: const Icon(Icons.highlight_off),
                      onPressed: () {
                        BlocProvider.of<SelectGuardiansBloc>(context).add(OnUserRemoved(user));
                      },
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
