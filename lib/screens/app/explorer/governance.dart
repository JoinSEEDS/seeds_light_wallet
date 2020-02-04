import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_card.dart';

class Governance extends StatefulWidget {

  @override
  GovernanceState createState() => GovernanceState();
}

class GovernanceState extends State<Governance> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);
  }

  Widget buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        indicatorColor: AppColors.blue,
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.grey,
        controller: controller,
        tabs: <Widget>[
          Tab(
            text: 'Open',
          ),
          Tab(
            text: 'Executed',
          ),
          Tab(
            text: 'Canceled',
          ),
          Tab(
            text: 'Expired',
          )
        ],
      )
    );
  }

  Widget buildCard() {
    final title = 'title';
    final summary = 'summary';
    final creator = 'creator';
    final date = '50 years ago';
    final url = 'url';
    final posVotes = 900;
    final negVotes = 100;
    final ratio = posVotes.toDouble() / max(posVotes + negVotes, 1);
    final width = MediaQuery.of(context).size.width;

    return MainCard(
      margin: EdgeInsets.all(17),
      padding: EdgeInsets.all(17),
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: Image(
                width: width * 0.5,
                image: AssetImage('assets/images/logo_title.png')
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(summary,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(url,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.blue,
                  decoration: TextDecoration.underline
                ),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Created by: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey
                        )
                      ),
                      TextSpan(
                        text: creator,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        )
                      )
                    ]
                  )
                ), 
                Text(date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 13),
              child: Text('${negVotes + posVotes} votes',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  Container(
                    height: 13,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    //for better view if neg votes too low
                    width: width * max(1 - ratio, 0.02),
                    height: 13,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Yes: ',
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        TextSpan(
                          text: '$posVotes votes',
                          style: TextStyle(
                            color: AppColors.grey
                          )
                        )
                      ]
                    )
                  ), 
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'No: ',
                          style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        TextSpan(
                          text: '$negVotes votes',
                          style: TextStyle(
                            color: AppColors.grey
                          )
                        )
                      ]
                    )
                  ), 
                ],
              )
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('Governance',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
        body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              buildTabs(),
              buildCard()
            ],
          )
        ),
      )
    );
  }
}
