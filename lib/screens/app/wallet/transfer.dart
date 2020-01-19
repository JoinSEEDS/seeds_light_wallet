import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:seeds/widgets/progress_bar.dart';

import 'transfer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Transfer extends StatefulWidget {
  Transfer();

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future onContact(String imageUrl, String fullName, String userName) async {
    await NavigationService.of(context).navigateTo(
      Routes.transferForm,
      TransferFormArguments(
        fullName,
        userName,
        imageUrl,
      ),
    );

    TransactionsNotifier.of(context).fetchTransactions();
    BalanceNotifier.of(context).fetchBalance();
  }

  Widget buildContact(String imageUrl, String fullName, String userName) {
    return InkWell(
        onTap: () => onContact(imageUrl, fullName, userName),
        child: Column(children: [
          Divider(height: 22),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15),
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
                                      ? Image.network(imageUrl)
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
                              tag: 'avatar#$userName')),
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
                                        tag: 'nickname#$userName'),
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
                                        tag: 'account#$userName'),
                                  ])))
                    ],
                  )),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppColors.blue,
                  )
                ],
              ))
        ]));
  }

  Widget buildList(String title, List<MemberModel> members) {
    final width = MediaQuery.of(context).size.width;
    return MainCard(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 15, bottom: 7),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Column(
                  children: <Widget>[
                    ...members
                        .map((member) => buildContact(
                            member.image, member.nickname, member.account))
                        .toList(),
                  ],
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Transfer",
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(17),
          child: Consumer<MembersNotifier>(
            builder: (ctx, model, _) {
              return model != null && model.members != null
                  ? buildList('All users', model.members)
                  : ProgressBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _usersList(context) {
    print("[widget] rebuild users");

    return Consumer<MembersNotifier>(builder: (ctx, model, _) {
      return model != null && model.members != null
          ? LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 500,
              showChildOpacityTransition: true,
              backgroundColor: AppColors.lightGreen,
              color: AppColors.lightBlue,
              onRefresh: () async {
                Provider.of<MembersNotifier>(context, listen: false)
                    .fetchMembers();
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: model.members.length,
                itemBuilder: (ctx, index) {
                  final user = model.members[index];

                  return ListTile(
                      leading: Hero(
                          child: Container(
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    CachedNetworkImageProvider(user.image)),
                          ),
                          tag: "avatar#${user.account}"),
                      title: Hero(
                        child: Material(
                          child: Text(
                            user.nickname,
                            style: TextStyle(fontFamily: "worksans"),
                          ),
                          color: Colors.transparent,
                        ),
                        tag: "nickname#${user.account}",
                      ),
                      subtitle: Hero(
                        child: Material(
                          child: Text(
                            user.account,
                            style: TextStyle(fontFamily: "worksans"),
                          ),
                          color: Colors.transparent,
                        ),
                        tag: "account#${user.account}",
                      ),
                      onTap: () {});
                },
              ),
            )
          : ProgressBar();
    });
  }
}
