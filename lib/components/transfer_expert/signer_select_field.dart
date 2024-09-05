import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/navigation/navigation_service.dart';

class SignerSelectField extends StatefulWidget {
  final String? account;
  final bool? enabled; 
  const SignerSelectField({this.account, this.enabled, super.key});

  @override
  _SignerSelectFieldState createState() => _SignerSelectFieldState();
}

class _SignerSelectFieldState extends State<SignerSelectField> {
  static const String addAccountLabel = "add account";
  late List<String> authAccounts;// get from 
  String selectedId = settingsStorage.selectedToken.id;
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  void handleAuthSelect(String s) async {
    if (s == addAccountLabel) {
      print("navigate to new auth account entry screen");
      final result = await NavigationService.of(context).navigateTo(Routes.newAuthAccount, null, false) as String?;
      if (result != null) {
        authAccounts += [result];
      }
    } else {
      authAccounts.remove(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialAuthAccounts = ["me", "my", "mine"]; //context.select((TransferExpertState state) => state.authorizedAccounts);
    authAccounts = initialAuthAccounts;
    return  PopupMenuButton(
    offset: const Offset(0, 40),
    elevation: 2,
    onSelected: (String s) {
      handleAuthSelect(s);
    },
    itemBuilder: (context) => (authAccounts
                  .sorted((a, b) => a.compareTo(b)) + [addAccountLabel])
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
                                child: Text(c,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                c == addAccountLabel ? Icons.add_circle
                                     : Icons.delete
                              )

                            ]
                                  ),
                                ),
                              ),
                          ).toList(),
    child: 
        Icon(Icons.edit_note),
    );
  }
}
