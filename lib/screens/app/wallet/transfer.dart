import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
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
          "Choose recipient",
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
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

  Widget _usersList(context) {
    print("[widget] rebuild users");

    return Consumer<MembersNotifier>(builder: (ctx, model, _) {
      return model != null && model.members != null
          ? LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 500,
              showChildOpacityTransition: true,
              backgroundColor: CustomColors.lightGreen,
              color: CustomColors.lightBlue,
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
                    leading: Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              CachedNetworkImageProvider(user.image)),
                    ),
                    title: Text(
                      user.nickname,
                      style: TextStyle(fontFamily: "worksans"),
                    ),
                    subtitle: Text(
                      user.account,
                      style: TextStyle(fontFamily: "worksans"),
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
                },
              ),
            )
          : ProgressBar();
    });
  }
}
