import 'package:flutter/material.dart';
import 'package:seeds/customColors.dart';

import './seedsButton.dart';

class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: CustomColors.Green),
              ),
            ),
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Connect friends - build trust",
                  style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Container(
                    width: 42,
                    child: Icon(
                      Icons.star_half,
                      color: CustomColors.Green,
                    ),
                  ),
                  title: Text("Reputation Rating: 80/100"),
                  subtitle: Text("Vouch for members to increase your reputation"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("GUEST"),
                  subtitle: Text("Your account status"),
                  trailing: SeedsButton("Upgrade"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("120 points"),
                  subtitle: Text("Your account reputation"),
                  trailing: SeedsButton("History"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("seedsgifting"),
                  subtitle: Text("Organization invited you"),
                  trailing: SeedsButton("Details"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("3 members"),
                  subtitle: Text("Members invited by you"),
                  trailing: SeedsButton("Show"),
                ),
              ),
              Container(
                child: ListTile(
                    title: Text("5 members"),
                    subtitle: Text("Vouched for your account"),
                    trailing: SeedsButton("Show")),
              ),
              Container(
                child: ListTile(
                  title: Text("5 members"),
                  subtitle: Text("You vouched for members"),
                  trailing: SeedsButton("Vouch"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
