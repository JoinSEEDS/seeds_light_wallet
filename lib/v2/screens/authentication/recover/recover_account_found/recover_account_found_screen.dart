import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/search_result_row.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/recover_account_found_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

class RecoverAccountFoundScreen extends StatelessWidget {
  const RecoverAccountFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>? userGuardians = ModalRoute.of(context)!.settings.arguments as List<String>?;
    return BlocProvider(
      create: (BuildContext context) => RecoverAccountFoundBloc(userGuardians ?? [])..add(FetchInitialData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Recover Account"),
        ),
        body: BlocBuilder<RecoverAccountFoundBloc, RecoverAccountFoundState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: TextFormFieldCustom(
                      enabled: false,
                      labelText: 'Link to Activate Key Guardians',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: state.linkToActivateGuardians)).then(
                            (value) {
                              SnackBarInfo("Copied", ScaffoldMessenger.of(context)).show();
                            },
                          );
                        },
                      ),
                      controller: TextEditingController(text: state.linkToActivateGuardians),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text("1", style: Theme.of(context).textTheme.button1),
                        Text("/3", style: Theme.of(context).textTheme.button1),
                        const SizedBox(
                          width: 24,
                        ),
                        Flexible(
                          child: Text(
                            "Guardians have accepted your request to recover your account",
                            style: Theme.of(context).textTheme.buttonLowEmphasis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                    child: DividerJungle(),
                  ),
                  Expanded(
                    child: ListView(
                      children: state.userGuardiansData
                          .map((e) => SearchResultRow(
                                account: e.account,
                                imageUrl: e.image,
                                name: e.nickname,
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
