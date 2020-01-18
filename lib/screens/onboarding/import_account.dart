import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/widgets/seeds_button.dart';

class ImportAccount extends StatefulWidget {
  @override
  _ImportAccountState createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccount> {
  var accountNameController = MaskedTextController(
      text: Config.testingAccountName,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  var privateKeyController = TextEditingController(text: Config.testingPrivateKey);

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

                      AuthNotifier.of(context).saveAccount(accountName, privateKey);

                      NavigationService.of(context).navigateTo("Welcome", accountName, true);
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
