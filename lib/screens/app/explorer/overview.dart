import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/community/community.dart';
import 'package:seeds/screens/app/explorer/governance.dart';
import 'package:seeds/widgets/main_card.dart';
// import 'package:seeds/widgets/seeds_button.dart';

class Overview extends StatelessWidget {
  const Overview({
    Key key,
  }) : super(key: key);

  Widget buildCategory(String title, String subtitle, String iconName, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: MainCard(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.only(right: 15),
              // child: Image(
              //   image: AssetImage(iconName),
              // ),
              child: SvgPicture.asset(iconName)
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                    )
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempo ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w300,
                      fontSize: 12
                    )
                  )
                ]
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
            buildCategory('Governance','', 'assets/images/governance.svg', () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => Governance()));
              //NavigationService.of(context).navigateTo(Routes.proposals);
            }),
            buildCategory('Community','', 'assets/images/community.svg', () {
               Navigator.push(context, MaterialPageRoute(builder: (ctx) => Community()));
              // NavigationService.of(context).navigateTo(Routes.invites);
            }),
            buildCategory('Exchange','', 'assets/images/exchange.svg', () {}),
            buildCategory('Lending','', 'assets/images/lending.svg', () {}),
            buildCategory('Harvest','', 'assets/images/harvest.svg', () {})
            // buildCategory('Governance', 'assets/images/explorer1.png', () {
            //   NavigationService.of(context).navigateTo(Routes.proposals);
            // }),
            // buildCategory('Community', 'assets/images/explorer2.png', () {
            //   NavigationService.of(context).navigateTo(Routes.invites);
            // }),
            // buildCategory('Exchange', 'assets/images/explorer3.png', () {}),
            // buildCategory('Lending', 'assets/images/explorer4.png', () {}),
            // buildCategory('Harvest', 'assets/images/explorer5.png', () {})
          ],
        )
      ),
    );
  }
}
