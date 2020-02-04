import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/community/code.dart';
import 'package:seeds/screens/app/explorer/community/transfer.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_card.dart';

import 'package:provider/provider.dart';
import 'package:seeds/widgets/transaction_dialog.dart';

class Community extends StatefulWidget {

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community>
    with AutomaticKeepAliveClientMixin<Community> {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('Community',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children:[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text('Recent invited',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    children: List.generate(5, 
                      (index) {
                        return buildRecentInvite('fullname', 'username', null, '5.00 SEEDS', '10.00 SEEDS');
                      }
                    )
                  ),
                  Divider(height: 1),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text('Active invite',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    children: List.generate(5, 
                      (index) {
                        return buildActiveInvite('fdsfds232f232f32fdsfddfsd3223f', '5.00 SEEDS', '10.00 SEEDS');
                      }
                    )
                  ),
                ]
              ),
            )
          ),
          MainButton(
            title: 'Create new invite',
            margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            onPressed: onInvite,
          )
        ]
      )
    );
  }

  @override
  initState() {
    super.initState();
  }


  void onRecentInvite() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => Transfer()));
  }

  void onActiveInvite() {

  }

  void onInvite() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => Code()));  
  }

  Widget buildRecentInvite(String fullName, String userName, String imageUrl, String sow, String transfer) {
     return InkWell(
        onTap: ()=> onRecentInvite(),
        child: Container(
          padding: EdgeInsets.only(bottom: 12),
          child: Column(
          children: [
            Divider(height: 1),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 12),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Hero(
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  color: AppColors.blue,
                                  child: imageUrl != null
                                    ? CachedNetworkImage(imageUrl: imageUrl)
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          fullName
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                              tag: 'avatar#${userName}')),
                      Flexible(
                          child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                        child: Container(
                                          child: Text(
                                            fullName,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                        tag: 'nickname${userName}'),
                                    Hero(
                                        child: Container(
                                          child: Text(
                                            userName,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 14),
                                          ),
                                        ),
                                        tag: 'account#$userName}'),
                                  ])))
                    ],
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Sow: $sow',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                      Text('Transfer: $transfer',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      )
                    ],
                  )
                ],
              ))
        ])));
  }

  Widget buildActiveInvite(String key, String sow, String transfer) {
     return InkWell(
      onTap: ()=> onActiveInvite(),
      child: Container(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Divider(height: 1),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: AppColors.gradient
                            )
                          ),
                          child: SvgPicture.asset('assets/images/share.svg',),
                        ),
                        Flexible(
                          child: Text(key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Sow: $sow',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                      Text('Transfer: $transfer',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      )
                    ],
                  )
                ],
              )
            )
          ]
        )
      )
    );
  }

}