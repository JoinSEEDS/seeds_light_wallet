import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/shared/shimmer_tile.dart';
import 'package:seeds/screens/shared/user_tile.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

import 'transfer_form.dart';

class Transfer extends StatefulWidget {
  const Transfer();

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  bool showSearch = false;

  FocusNode? _searchFocusNode;

  @override
  void dispose() {
    _searchFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            MembersNotifier.of(context).filterMembers('');
            Navigator.of(context).pop();
          },
        ),
        title: showSearch
            ? Container(
                decoration: const BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: TextField(
                  autofocus: true,
                  autocorrect: false,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 17),
                    hintText: 'Enter user name or account'.i18n,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  onChanged: (text) {
                    MembersNotifier.of(context).filterMembers(text);
                  },
                ),
              )
            : Text(
                "Transfer".i18n,
                style: const TextStyle(fontFamily: "worksans", color: Colors.black),
              ),
        centerTitle: true,
        actions: <Widget>[
          if (!showSearch)
            IconButton(
              icon: const Icon(
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
              icon: const Icon(
                Icons.highlight_off,
                color: Colors.black,
              ),
              onPressed: () {
                _searchFocusNode!.unfocus();

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
      // MembersNotifier.of(context).fetchMembersCache();
      MembersNotifier.of(context).refreshMembers();
    });
    super.initState();
    _searchFocusNode = FocusNode();
  }

  Widget _usersList(context) {
    return Consumer<MembersNotifier>(builder: (ctx, model, _) {
      return (model.visibleMembers.isEmpty && showSearch == true)
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 7,
              ),
              child: Text(
                "Choose existing Seeds Member to transfer".i18n,
                style: const TextStyle(fontFamily: "worksans", fontSize: 18, fontWeight: FontWeight.w300),
              ),
            )
          : LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 500,
              showChildOpacityTransition: true,
              backgroundColor: AppColors.lightGreen,
              color: AppColors.lightBlue,
              onRefresh: () async {
                await Provider.of<MembersNotifier>(context, listen: false).refreshMembers();
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: model.visibleMembers.length > 8
                    ? model.visibleMembers.length
                    : (showSearch == true ? model.visibleMembers.length : 8),
                itemBuilder: (ctx, index) {
                  if (model.visibleMembers.length <= index) {
                    return shimmerTile();
                  } else {
                    final user = model.visibleMembers[index];
                    return userTile(
                        user: user,
                        onTap: () async {
                          await NavigationService.of(context).navigateTo(
                            Routes.transferForm,
                            TransferFormArguments(
                              user.nickname,
                              user.account,
                              user.image,
                            ),
                          );
                        });
                  }
                },
              ),
            );
    });
  }
}
