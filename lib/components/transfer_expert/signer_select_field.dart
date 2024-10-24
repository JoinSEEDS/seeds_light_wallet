import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/eosaccount_repository.dart';
import 'package:seeds/datasource/remote/model/eos_account_model.dart';
import 'package:seeds/datasource/remote/model/eos_permissions_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

class SignerSelectField extends StatefulWidget {
  final String? account;
  final bool enabled;
  const SignerSelectField({this.account, this.enabled = false, super.key});

  @override
  _SignerSelectFieldState createState() => _SignerSelectFieldState();
}

class _SignerSelectFieldState extends State<SignerSelectField> {
  static const String addAccountLabel = "add account";
  static const String updatePermissionsLabel = "update now";
  final EOSAccountRepository _accountRepository = EOSAccountRepository();
  List< String> authAccounts = [];
  String selectedId = settingsStorage.selectedToken.id;
  String? fromAccount;

  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  void handleAuthSelect(String s, String? fromAccount) async {
    if (s == addAccountLabel) {
      print("navigate to new auth account entry screen");
      final result = await NavigationService.of(context).navigateTo(Routes.newAuthAccount, null, false) as String?;
      if (result != null) {
        authAccounts += [result+'@active@1'];
      }
    } else if (s == updatePermissionsLabel && fromAccount != null) {
      // build transaction and navigate to confirmation screen
      final account_info = (await _accountRepository.getEOSAccount(fromAccount)).asValue!.value;
      final oldRequiredAuth = account_info.permissions.permissions
        .firstWhere((p) => p.perm_name == "active" && p.parent == "owner").required_auth;
      List<EOSAccountAuth> newAccountAuths = authAccounts.map((account) => EOSAccountAuth(
        permission: EOSAccountAuthPermission(
          actor: account.split('@')[0],
          permission:account.split('@')[1]
        ),
        weight: int.parse(account.split('@')[2]))).toList();
      final newRequiredAuth = oldRequiredAuth.copyWith(accounts: newAccountAuths);

      final updateAuthTrx = EOSTransaction.fromAction(
        account: "eosio",
        actionName: "updateauth",
        data: {
          "account": fromAccount,
          "permission": "active",
          "parent": "owner",
          "auth": newRequiredAuth.toJson(),
        }
      );
      eos.Authorization auth = eos.Authorization();
      auth.actor = fromAccount;
      auth.permission = "active";
      updateAuthTrx.actions[0].authorization = [auth];
      final args = SendConfirmationArguments(transaction: updateAuthTrx);
      final result = (await NavigationService.of(context).navigateTo(Routes.sendConfirmation, args, false)).toString();
    } else {
      authAccounts.remove(s);
    }
  }
 
  

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferExpertBloc, TransferExpertState>(
      listenWhen: (previous, current) => 
        current.selectedAccounts["from"] != previous.selectedAccounts["from"],
      listener: (context, state) {
        fromAccount = state.selectedAccounts["from"];
        try {
          authAccounts = state.accountPermissions["from"]!.permissions.permissions
            .firstWhere((p) => p.perm_name == "active" && p.parent == "owner")
            .required_auth.accounts.map((e) => 
              '${e.permission.actor}@${e.permission.permission}@${e.weight}').toList();
        } catch (e) { print ('signerselect on invalid account $fromAccount : $e'); };
        print('From $fromAccount');
      },
    child:  PopupMenuButton(
    enabled: widget.enabled,
    offset: const Offset(0, 40),
    elevation: 2,
    onSelected: (String s) {
      handleAuthSelect(s, fromAccount);
    },
    itemBuilder: (context) => (authAccounts.where((element) => element.split('@')[1]=="active")
                  .sorted((a, b) => a.compareTo(b)) + [addAccountLabel, updatePermissionsLabel])
                    .map<PopupMenuEntry<String>>(
                      (c) => PopupMenuItem<String>(
                        value: c,
                        child: SizedBox(
                          height: 40,
                          // width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(c.split('@')[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                c == addAccountLabel ? Icons.add_circle
                                  : c == updatePermissionsLabel ? Icons.upgrade
                                    : Icons.delete
                              )

                            ]
                                  ),
                                ),
                              ),
                          ).toList(),
    child: 
        Icon(
          Icons.edit_note,
            size: 36,
            // TODO use theme colors
            color: widget.enabled ? Colors.white : Colors.white30,),
    )
    );
  }
}
