import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/backup/backup_service.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_message_token_repository.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/second_button.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool privateKeySaved = false;

  void onLogout() {
    String userAccount = SettingsNotifier.of(context).accountName;
    SettingsNotifier.of(context).removeAccount();
    FirebaseMessageTokenRepository().removeFirebaseMessageToken(userAccount);
    // Hive.deleteBoxFromDisk("members");
    // Hive.deleteBoxFromDisk("transactions");
  }

  @override
  Widget build(BuildContext context) {
    final backupService = Provider.of<BackupService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Logout".i18n,
          style: TextStyle(color: Colors.black, fontFamily: "worksans"),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/logout.svg',
                    width: 100.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    'Save private key in secure place - to be able to restore access to your wallet later'.i18n,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MainButton(
                  title: "Save private key".i18n,
                  onPressed: () {
                    setState(() {
                      privateKeySaved = true;
                    });
                    backupService.backup();
                  },
                ),
                if (privateKeySaved == true)
                  SecondButton(
                    margin: const EdgeInsets.only(top: 10, bottom: 40.0),
                    title: "Logout".i18n,
                    onPressed: onLogout,
                    color: AppColors.red,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
