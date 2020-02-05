import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:share/share.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool privateKeySaved = false;

  void onLogout() {
    SettingsNotifier.of(context).removeAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Logout",
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Save private key in secure place - to be able to restore access to your wallet later",
              style: TextStyle(fontFamily: "worksans", fontSize: 18),
            ),
            SizedBox(height: 14),
            MainButton(
              title: "Save private key",
              onPressed: () {
                setState(() {
                  privateKeySaved = true;
                });
                Share.share(SettingsNotifier.of(context).privateKey);
              },
            ),
            SizedBox(height: 12),
            privateKeySaved == true
                ? MainButton(
                    title: "Logout",
                    onPressed: onLogout,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}