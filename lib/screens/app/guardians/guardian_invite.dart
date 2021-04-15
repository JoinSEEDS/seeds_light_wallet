import 'package:flutter/material.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/shared/user_tile.dart';
import 'package:seeds/utils/old_toolbox/toast.dart';
import 'package:seeds/widgets/main_button.dart';

class InviteGuardians extends StatefulWidget {
  final Set<MemberModel>? selectedUsers;

  const InviteGuardians(this.selectedUsers);

  @override
  _InviteGuardiansState createState() => _InviteGuardiansState(selectedUsers);
}

class _InviteGuardiansState extends State<InviteGuardians> {
  final Set<MemberModel>? selectedUsers;

  _InviteGuardiansState(this.selectedUsers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Invite Guardians".i18n,
          style: const TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InviteGuardianBody(selectedUsers),
    );
  }
}

class InviteGuardianBody extends StatefulWidget {
  final Set<MemberModel>? selectedUsers;
  final savingLoader = GlobalKey<MainButtonState>();

  InviteGuardianBody(this.selectedUsers);

  @override
  _InviteGuardianBodyState createState() => _InviteGuardianBodyState();
}

class _InviteGuardianBodyState extends State<InviteGuardianBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(child: const Icon(Icons.email_outlined, size: 120)),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "The users below will be sent an invite to become your Guardian.".i18n,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: widget.selectedUsers!.map((e) => userTile(user: e, onTap: null)).toList(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MainButton(
            key: widget.savingLoader,
            margin: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16),
            title: 'Send Invite'.i18n,
            onPressed: () => {
              widget.savingLoader.currentState!.loading(),
              FirebaseDatabaseService()
                  .sendGuardiansInvite(SettingsNotifier.of(context).accountName, widget.selectedUsers!.toList())
                  .catchError((onError) => onSendInviteError(onError))
                  .then((value) => NavigationService.of(context).navigateTo(Routes.inviteGuardiansSent))
            },
          ),
        ),
      ],
    );
  }

  void onSendInviteError(onError) {
    print(onError.toString());
    errorToast('Oops, Something went wrong.');
    widget.savingLoader.currentState!.done();
  }
}
