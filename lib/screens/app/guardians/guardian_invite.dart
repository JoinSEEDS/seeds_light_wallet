import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/shared/user_tile.dart';
import 'package:seeds/widgets/main_button.dart';

class InviteGuardians extends StatefulWidget {
  final Set<MemberModel> selectedUsers;

  InviteGuardians(this.selectedUsers);

  @override
  _InviteGuardiansState createState() => _InviteGuardiansState(selectedUsers);
}

class _InviteGuardiansState extends State<InviteGuardians> {
  final Set<MemberModel> selectedUsers;
  bool loading = false;

  _InviteGuardiansState(this.selectedUsers);

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
      body: InviteGuardianBody(selectedUsers),
    );
  }
}

class InviteGuardianBody extends StatelessWidget {
  final Set<MemberModel> selectedUsers;

  InviteGuardianBody(this.selectedUsers);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(child: Icon(Icons.email_outlined, size: 120)),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "The users below will be sent an invite to become your Guardian.".i18n,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: selectedUsers.map((e) => userTile(user: e, onTap: null)).toList(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MainButton(
            margin: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16),
            title: 'Send Invite'.i18n,
            onPressed: () => {
              NavigationService.of(context).navigateTo(Routes.inviteGuardiansSent),
            },
          ),
        ),
      ],
    );
  }
}
