import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/clipboard_text_field.dart';
import 'package:seeds/widgets/main_button.dart';

enum ImportStatus {
  emptyPrivateKey,
  loadingAccounts,
  invaildPrivateKey,
  noAccounts,
  foundAccounts
}

class ImportAccount extends StatefulWidget {
  final Function onImport;

  ImportAccount({this.onImport});

  @override
  _ImportAccountState createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccount> {
  var privateKeyController =
      TextEditingController(text: Config.testingPrivateKey);

  List<String> availableAccounts;
  String chosenAccount;

  ImportStatus status = ImportStatus.emptyPrivateKey;

  void discoverAccounts() async {
    print("discover accounts");

    String privateKey = privateKeyController.text;
    String publicKey = "";

    if (privateKey == "") {
      setState(() => status = ImportStatus.emptyPrivateKey);
      return;
    }

    setState(() => status = ImportStatus.loadingAccounts);

    try {
      EOSPrivateKey eosPrivateKey = EOSPrivateKey.fromString(privateKey);
      EOSPublicKey eosPublicKey = eosPrivateKey.toEOSPublicKey();
      publicKey = eosPublicKey.toString();
    } catch (_) {}

    if (publicKey == "") {
      setState(() => status = ImportStatus.invaildPrivateKey);
      return;
    }

    List<String> keyAccounts =
        await Provider.of<HttpService>(context, listen: false)
            .getKeyAccounts(publicKey);

    if (keyAccounts == null || keyAccounts.length == 0) {
      setState(() => status = ImportStatus.noAccounts);
      return;
    }

    setState(() {
      status = ImportStatus.foundAccounts;
      availableAccounts = keyAccounts;
      chosenAccount = availableAccounts[0];
    });
  }

  void onImport() {
    String accountName = chosenAccount;
    String privateKey = privateKeyController.value.text;

    widget.onImport(accountName: accountName, privateKey: privateKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 33,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipboardTextField(
            controller: privateKeyController,
            labelText: "Private key",
            hintText: "Paste from clipboard",
            onChanged: discoverAccounts,
          ),
          SizedBox(height: 12),
          status == ImportStatus.loadingAccounts
              ? Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 5),
                      Text("Looking for accounts..."),
                    ],
                  ),
                )
              : Container(),
          status == ImportStatus.noAccounts
              ? Center(
                  child: Text("No accounts found associated with given key"),
                )
              : Container(),
          status == ImportStatus.invaildPrivateKey
              ? Center(
                  child: Text("Given private key is not valid"),
                )
              : Container(),
          status == ImportStatus.foundAccounts
              ? Column(
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
              : Container()
        ],
      ),
    );
  }
}
