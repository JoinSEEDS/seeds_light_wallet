import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_card.dart';

class Overview extends StatefulWidget {

  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {

  void onInvite() {

  }

  Widget buildCategory(String title, String iconName, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: MainCard(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.only(right: 15),
              child: Image(
                image: AssetImage(iconName),
              ),
            ),
            Flexible(
              child: Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                )
              )
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(17),
        child: Column(
          children: <Widget>[
            buildCategory('Invite', 'assets/images/explorer_icon.png', onInvite),
            buildCategory('Section', 'assets/images/explorer_icon.png', onInvite),
            buildCategory('Section', 'assets/images/explorer_icon.png', onInvite),
          ],
        )
      ),
    );
  }
}
