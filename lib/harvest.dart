import 'package:flutter/material.dart';

import 'customColors.dart';
// import 'harvestForm.dart';
import './seedsButton.dart';

class Harvest extends StatelessWidget {
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
                  "Plant SEEDS - get SEEDS",
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
                  title: Text("Staking Rating: 50/100"),
                  subtitle: Text("Plant SEEDS to increase your staking"),
                ),
              ),
              Container(
                child: ListTile(
                    title: Text("25.0000 SEEDS"),
                    subtitle: Text("Currently planted"),
                    trailing: SeedsButton("Plant")),
              ),
              Container(
                child: ListTile(
                  title: Text("10.0000 SEEDS"),
                  subtitle: Text("In process of unplanting"),
                  trailing: SeedsButton("Unplant"),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("15.0000 SEEDS"),
                  subtitle: Text("Available reward"),
                  trailing: SeedsButton("Claim"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
