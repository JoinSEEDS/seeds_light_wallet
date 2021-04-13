

import 'package:flutter/material.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';

class InviteGuardiansSent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Invite Guardians".i18n,
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InviteGuardianSentBody(),
    );
  }
}

class InviteGuardianSentBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(child: Icon(Icons.check_circle, size: 120)),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "Invites Sent!".i18n,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MainButton(
              margin: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16),
              title: 'Ok'.i18n,
              onPressed: () => {
                Navigator.popUntil(context, ModalRoute.withName('/')),
                NavigationService.of(context).navigateTo(Routes.guardianTabs)
              },
            ),
          ),
        ),
      ],
    );
  }
}
