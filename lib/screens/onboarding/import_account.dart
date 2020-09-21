import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/clipboard_text_field.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/import_account.i18n.dart';

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
  var privateKeyController = TextEditingController();

  List<String> availableAccounts;
  String chosenAccount;

  ImportStatus status = ImportStatus.emptyPrivateKey;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // if (Config.testingPrivateKey != null) {
      //   privateKeyController.text = Config.testingPrivateKey;
      // }
      discoverAccounts();
    });
  }

  @override
  void dispose() {
    privateKeyController.dispose();
    super.dispose();
  }

  void discoverAccounts() async {
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
            labelText: "Private key".i18n,
            hintText: "Paste from clipboard".i18n,
            onChanged: discoverAccounts,
          ),
          SizedBox(height: 12),
          status == ImportStatus.emptyPrivateKey
              ? Center(
                  child: Text(
                    "If you already have Seeds account - enter active private key and account will be imported automatically".i18n,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "worksans",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : Container(),
          status == ImportStatus.loadingAccounts
              ? Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 5),
                      Text("Looking for accounts...".i18n),
                    ],
                  ),
                )
              : Container(),
          status == ImportStatus.noAccounts
              ? Center(
                  child: Text("No accounts found associated with given key".i18n),
                )
              : Container(),
          status == ImportStatus.invaildPrivateKey
              ? Center(
                  child: Text("Given private key is not valid".i18n),
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
                        hint: Text("Account name".i18n),
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
                      title: 'Import account'.i18n,
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
