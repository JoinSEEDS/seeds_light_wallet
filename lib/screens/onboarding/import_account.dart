import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:provider/provider.dart';

class ImportAccount extends StatefulWidget {
  @override
  _ImportAccountState createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccount> {
  var accountNameController = MaskedTextController(
      text: Config.testingAccountName,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  var privateKeyController =
      TextEditingController(text: Config.testingPrivateKey);

  bool progress = false;
  bool isEmptyField = true;
  bool invalidPrivateKey = false;
  bool noAccountsFound = false;

  String chosenAccount;
  List<String> availableAccounts;

  @override
  void didChangeDependencies() {
    if (privateKeyController.text != "" && chosenAccount == null) {
      setState(() {
        isEmptyField = false;
      });
      discoverAccounts();
    }
    super.didChangeDependencies();
  }

  void discoverAccounts() async {
    print("discover accounts");

    setState(() {
      progress = true;
      noAccountsFound = false;
      invalidPrivateKey = false;
    });

    String publicKeyRaw;

    try {
      EOSPrivateKey privateKey = EOSPrivateKey.fromString(
        privateKeyController.text,
      );

      EOSPublicKey publicKey = privateKey.toEOSPublicKey();

      publicKeyRaw = publicKey.toString();
    } catch (err) {
      setState(() {
        invalidPrivateKey = true;
        progress = false;
      });
    }

    if (publicKeyRaw != null) {
      print("publicKeyRaw: $publicKeyRaw");

      List<String> keyAccounts = await Provider.of<HttpService>(context, listen: false).getKeyAccounts(publicKeyRaw);      

      if (keyAccounts != null && keyAccounts.length > 0) {
        setState(() {
          progress = false;
          availableAccounts = keyAccounts;
          chosenAccount = availableAccounts[0];
        });
      } else {
        setState(() {
          progress = false;
          noAccountsFound = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      title: "Import account",
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              autofocus: false,
              controller: privateKeyController,
              onChanged: (val) {
                if (val == "" && isEmptyField == false) {
                  setState(() {
                    isEmptyField = true;
                  });
                } else if (val != "" && isEmptyField == true) {
                  setState(() {
                    isEmptyField = false;
                  });
                }
                discoverAccounts();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blue, width: 2),
                ),
                labelText: "Private key",
                suffixIcon: isEmptyField
                    ? IconButton(
                        icon: Icon(Icons.content_paste),
                        onPressed: () async {
                          ClipboardData clipboardData =
                              await Clipboard.getData('text/plain');
                          String privateKeyClipboard =
                              clipboardData?.text ?? '';
                          privateKeyController.text = privateKeyClipboard;
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            isEmptyField = false;
                          });
                          discoverAccounts();
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => privateKeyController.clear());
                          setState(() {
                            isEmptyField = true;
                            availableAccounts = null;
                          });
                        },
                      ),
                hintText: "Paste from clipboard",
              ),
              style: TextStyle(
                fontFamily: "sfprotext",
              ),
            ),
            SizedBox(height: 12),
            progress == false
                ? Container()
                : Center(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Looking for accounts..."),
                      ],
                    ),
                  ),
            noAccountsFound == false
                ? Container()
                : Center(
                    child: Text("No accounts found associated with given key"),
                  ),
            invalidPrivateKey == false
                ? Container()
                : Center(
                    child: Text("Given private key is not valid"),
                  ),
            availableAccounts == null
                ? Container()
                : Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3.0),
                          ),
                          border: new Border.all(
                            color: AppColors.blue,
                            width: 2,
                          ),
                        ),
                        child: DropdownButton(
                          underline: Container(height: 0),
                          hint: Text("Account name"),
                          isExpanded: true,
                          value: chosenAccount,
                          onChanged: (val) {
                            setState(() {
                              chosenAccount = val;
                            });
                          },
                          items: availableAccounts.map((val) {
                            return new DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16),
                      MainButton(
                        title: 'Import account',
                        onPressed: onImport,
                      ),
                      SizedBox(height: 20),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void onImport() {
    String accountName = chosenAccount;
    String privateKey = privateKeyController.value.text;

    AuthNotifier.of(context).saveAccount(accountName, privateKey);

    NavigationService.of(context).navigateTo(Routes.welcome, accountName, true);
  }
}
