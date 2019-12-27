import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/widgets/overlayPopup.dart';
import 'package:seeds/widgets/seedsButton.dart';

import 'create_account.dart';

class ClaimCode extends StatefulWidget {
  @override
  _ClaimCodeState createState() => _ClaimCodeState();
}

class _ClaimCodeState extends State<ClaimCode> {
  var inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      title: "Claim code",
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
                    "Invite code",
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
                    controller: inviteCodeController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Accept invite", () async {
                String inviteCode = inviteCodeController.value.text;

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => CreateAccount(inviteCode)),
                );
              }),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Paste from clipboard", () async {
                ClipboardData clipboardData =
                    await Clipboard.getData('text/plain');
                String inviteCodeClipboard = clipboardData?.text ?? '';
                inviteCodeController.text = inviteCodeClipboard;
              }),
            ),
          ],
        ),
      ),
    );
  }
}