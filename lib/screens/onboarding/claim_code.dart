import 'package:flutter/material.dart';
import 'package:seeds/widgets/clipboard_text_field.dart';
import 'package:seeds/widgets/main_button.dart';

class ClaimCode extends StatefulWidget {
  final String inviteCode;
  final Function onClaim;

  ClaimCode({this.inviteCode, this.onClaim});

  @override
  _ClaimCodeState createState() => _ClaimCodeState();
}

class _ClaimCodeState extends State<ClaimCode> {
  var inviteCodeController = TextEditingController();

  @override
  void initState() {
    if (widget.inviteCode != null) {
      inviteCodeController.text = widget.inviteCode;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: ClipboardTextField(
            controller: inviteCodeController,
            labelText: "Invite code (5 words)",
          ),
        ),
        SizedBox(height: 16),
        MainButton(
          title: 'Claim code',
          margin: EdgeInsets.only(left: 33, right: 33, top: 10),
          onPressed: () => widget.onClaim(inviteCodeController.value.text),
        ),
      ],
    );
  }
}
