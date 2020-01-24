import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seeds/widgets/main_card.dart';

import 'transfer_form.dart';

class Transfer extends StatefulWidget {
  Transfer();

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer>
    with AutomaticKeepAliveClientMixin {
  bool is_search = false;

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
    var member_items = Provider.of<MembersNotifier>(context).members;
    var ctx = context;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: this.is_search
            ? this._searchBar(context, member_items, ctx)
            : Text(
                "Transfer",
                style: TextStyle(fontFamily: "worksans", color: Colors.black),
              ),
        centerTitle: true,
        actions: <Widget>[
          if (!this.is_search)
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                print(this.is_search);
                this.is_search = !this.is_search;
                setState(() {});
              },
            )
          else
            IconButton(
              icon: Icon(
                Icons.highlight_off,
              ),
              onPressed: () {
                this.is_search = !this.is_search;
                MembersNotifier.of(context).searchMembers('');
                setState(() {});
              },
            ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(17),
          child: Consumer<MembersNotifier>(
            builder: (ctx, model, _) {
              return model != null && model.membersSearch != null
                  ? buildList('All users', model.membersSearch)
                  : ProgressBar();
            },
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      MembersNotifier.of(context).fetchMembers();
    });
    super.initState();
  }

  Widget _usersList(context) {
    print("[widget] rebuild users");

    return Consumer<MembersNotifier>(builder: (ctx, model, _) {
      return LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 500,
        showChildOpacityTransition: true,
        backgroundColor: AppColors.lightGreen,
        color: AppColors.lightBlue,
        onRefresh: () async {
          Provider.of<MembersNotifier>(context, listen: false).fetchMembers();
        },
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: model?.members?.length ?? 8,
          itemBuilder: (ctx, index) {
            if (model?.members == null || model.members.isEmpty) {
              return _shimmerTile();
            } else {
              final user = model.members[index];
              return ListTile(
                leading: Hero(
                  child: Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(user.image),
                    ),
                  ),
                  tag: "avatar#${user.account}",
                ),
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
                onTap: () async {
                  await NavigationService.of(context).navigateTo(
                    Routes.transferForm,
                    TransferFormArguments(
                      user.nickname,
                      user.account,
                      user.image,
                    ),
                  );

                  TransactionsNotifier.of(context).fetchTransactions();
                  BalanceNotifier.of(context).fetchBalance();
                },
              );
            }
          },
        ),
      );
    });
  }

  Widget _searchBar(BuildContext contex, items, ctx) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 17),
          hintText: 'Search user',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
        onChanged: (text) {
          MembersNotifier.of(context).searchMembers(text);
          rebuildAllChildren(ctx);
        },
      ),
    );
  }

  Widget _shimmerTile() {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 12.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
      subtitle: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: 40.0,
          height: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }

  //Attention from Andrey MK! This is a hack call.Use it if you know exectly what you want!
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}
