import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/account_action_row.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/screens/explore_screens/flag/components/remove_flag_info_dialog.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_bloc.dart';

class FlagScreen extends StatelessWidget {
  const FlagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlagBloc()..add(const LoadUsersFlags()),
      child: BlocConsumer<FlagBloc, FlagState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Flag'.i18n)),
            body: ListView(
              children: state.usersIHaveFlagged
                  .map((ProfileModel member) => AccountActionRow(
                        image: member.image,
                        account: member.account,
                        nickname: member.nickname,
                        action: TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) => RemoveFlagInfoDialog(userAccount: member.account),
                            );
                          },
                          child: const Text(
                            "Remove Flag",
                            style: TextStyle(color: AppColors.red, fontSize: 12),
                          ),
                        ),
                        onTileTap: () {
                          // No - Op for now.
                        },
                      ))
                  .toList()
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
