import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:shimmer/shimmer.dart';

import 'transfer_form.dart';

class Transfer extends StatefulWidget {
  Transfer();

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  bool showSearch = false;

  FocusNode _searchFocusNode;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            MembersNotifier.of(context).filterMembers('');
            Navigator.of(context).pop();
          },
        ),
        title: showSearch
            ? Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: TextField(
                  autofocus: true,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Enter user name or account',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  onChanged: (text) {
                    MembersNotifier.of(context).filterMembers(text);
                  },
                ),
              )
            : Text(
                "Transfer",
                style: TextStyle(fontFamily: "worksans", color: Colors.black),
              ),
        centerTitle: true,
        actions: <Widget>[
          if (!showSearch)
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(_searchFocusNode);

                setState(() {
                  showSearch = true;
                });
              },
            )
          else
            IconButton(
              icon: Icon(
                Icons.highlight_off,
                color: Colors.black,
              ),
              onPressed: () {
                _searchFocusNode.unfocus();

                MembersNotifier.of(context).filterMembers('');
                
                setState(() {
                  showSearch = false;
                });
              },
            ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _usersList(context),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      MembersNotifier.of(context).fetchMembersCache();
      MembersNotifier.of(context).refreshMembers();
    });
    super.initState();
    _searchFocusNode = new FocusNode();
  }

  Widget _usersList(context) {
    return Consumer<MembersNotifier>(builder: (ctx, model, _) {
      return (model.visibleMembers.isEmpty && showSearch == true)
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 7,
              ),
              child: Text(
                "Choose existing Seeds Member to transfer",
                style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 18,
                    fontWeight: FontWeight.w200),
              ),
            )
          : LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 500,
              showChildOpacityTransition: true,
              backgroundColor: AppColors.lightGreen,
              color: AppColors.lightBlue,
              onRefresh: () async {
                Provider.of<MembersNotifier>(context, listen: false)
                    .refreshMembers();
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: model.visibleMembers.length > 8
                    ? model.visibleMembers.length
                    : (showSearch == true ? model.visibleMembers.length : 8),
                itemBuilder: (ctx, index) {
                  if (model.visibleMembers.length <= index) {
                    return _shimmerTile();
                  } else {
                    final user = model.visibleMembers[index];
                    return _userTile(user);
                  }
                },
              ),
            );
    });
  }

  Widget _userTile(MemberModel user) {
    return ListTile(
      leading: Hero(
        child: TransactionAvatar(
          size: 60,
          image: user.image,
          account: user.account,
          nickname: user.nickname,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
        ),
        tag: "avatar#${user.account}",
      ),
      title: Hero(
        child: Material(
          child: Text(
            user.nickname,
            style:
                TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w500),
          ),
          color: Colors.transparent,
        ),
        tag: "nickname#${user.account}",
      ),
      subtitle: Hero(
        child: Material(
          child: Text(
            user.account,
            style:
                TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w400),
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
      },
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
}
