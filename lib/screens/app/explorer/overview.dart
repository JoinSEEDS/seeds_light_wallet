import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_card.dart';
// import 'package:seeds/widgets/seeds_button.dart';

class Overview extends StatelessWidget {
  const Overview({
    Key key,
  }) : super(key: key);

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
            buildCategory('Governance', 'assets/images/explorer1.png', () {
              NavigationService.of(context).navigateTo(Routes.proposals);
            }),
            buildCategory('Community', 'assets/images/explorer2.png', () {
              NavigationService.of(context).navigateTo(Routes.invites);
            }),
            buildCategory('Exchange', 'assets/images/explorer3.png', () {}),
            buildCategory('Lending', 'assets/images/explorer4.png', () {}),
            buildCategory('Harvest', 'assets/images/explorer5.png', () {})
          ],
        )
      ),
    );
  }
}
