import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';

class ManageAccounts extends StatelessWidget {
  const ManageAccounts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.gradient),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                SettingsNotifier.of(context).accountName,
                style: TextStyle(
                  fontFamily: "worksans",
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: FlatButton(
              color: Colors.white,
              child: Text(
                'Export private key',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () =>
                  Share.share(SettingsNotifier.of(context).privateKey),
            ),
          ),
          FlatButton(
            color: Colors.white,
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () =>
                NavigationService.of(context).navigateTo(Routes.logout),
          )
        ],
      ),
    );
  }
}
