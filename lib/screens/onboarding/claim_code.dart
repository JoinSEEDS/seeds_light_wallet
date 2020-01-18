import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/widgets/seeds_button.dart';

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
            TextField(
              autofocus: true,
              controller: inviteCodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Invite code",
                suffixIcon: IconButton(
                  icon: Icon(Icons.content_paste),
                  onPressed: () async {
                    ClipboardData clipboardData =
                        await Clipboard.getData('text/plain');
                    String inviteCodeClipboard = clipboardData?.text ?? '';
                    inviteCodeController.text = inviteCodeClipboard;
                  },
                ),
                hintText: "Paste from clipboard",
              ),
              style: TextStyle(
                fontFamily: "sfprotext",
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Accept invite", () async {
                String inviteCode = inviteCodeController.value.text;

                NavigationService.of(context).navigateTo(Routes.createAccount, inviteCode);
              }),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
