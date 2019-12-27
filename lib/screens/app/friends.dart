import 'package:flutter/material.dart';
import 'package:seeds/constants/customColors.dart';
import 'package:seeds/widgets/seedsButton.dart';

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
                  "Build community - gain reputation",
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
                  title: Text("You invited 1 user of 2 required"),
                  subtitle: Text("Invite more users to upgrade your status and become citizen"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("GUEST"),
                  subtitle: Text("Your account status"),
                  trailing: SeedsButton("Progress"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("seedsgifting invited you"),
                  subtitle: Text("Create invite for your friends"),
                  trailing: SeedsButton("Invite"),
                ),
              ),
              Container(
                child: ListTile(
                    title: Text("5 / 20 requests sent"),
                    subtitle: Text("Request someone to vouch for you"),
                    trailing: SeedsButton("Request")),
              ),
              Container(
                child: ListTile(
                  title: Text("5 / 150 requests approved"),
                  subtitle: Text("Vouch for members waiting your approval"),
                  trailing: SeedsButton("Approve"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
