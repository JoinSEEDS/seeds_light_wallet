import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/screens/onboarding/welcome.dart';
import 'package:seeds/widgets/overlayPopup.dart';
import 'package:seeds/widgets/seedsButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';

class ImportAccount extends StatefulWidget {
  @override
  _ImportAccountState createState() => _ImportAccountState();
}

Future saveAccount(String accountName, String privateKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("accountName", accountName);
  await prefs.setString("privateKey", privateKey);
}

class _ImportAccountState extends State<ImportAccount> {
  var accountNameController = MaskedTextController(
      text: debugAccount,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  var privateKeyController = TextEditingController(text: debugPrivateKey);

  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      title: "Import account",
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    "Private key",
                    style: TextStyle(fontFamily: "sfprotext"),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.left,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    autofocus: true,
                    controller: privateKeyController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  flex: 4,
                  child: Text(
                    "Account name",
                    style: TextStyle(fontFamily: "sfprotext"),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.left,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    autofocus: true,
                    controller: accountNameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: progress
                  ? SeedsButton("Importing...")
                  : SeedsButton("Import account", () async {
                      setState(() {
                        progress = true;
                      });

                      String accountName = accountNameController.value.text;
                      String privateKey = privateKeyController.value.text;

                      await saveAccount(accountName, privateKey);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Welcome(accountName),
                      ));
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
