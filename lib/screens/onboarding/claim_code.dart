import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/clipboard_text_field.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/overlay_popup.dart';

class ClaimCode extends StatefulWidget {
  @override
  _ClaimCodeState createState() => _ClaimCodeState();
}

class _ClaimCodeState extends State<ClaimCode> {
  var inviteCodeController = TextEditingController();

  void onClaim() {
    String inviteCode = inviteCodeController.value.text;

    NavigationService.of(context).navigateTo(Routes.createAccount, inviteCode);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      title: "Claim code",
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipboardTextField(
              controller: inviteCodeController,
              labelText: "Invite code",
            ),
            SizedBox(height: 16),
            MainButton(
              title: 'Import account',
              onPressed: onClaim,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
