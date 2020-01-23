import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/seeds_button.dart';

import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  @override
  bool get wantKeepAlive => false;

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _titleText("Welcome, ${SettingsNotifier.of(context).accountName}"),
          _dashboardList(),
          _titleText("Latest transactions"),
          _transactionsList(context)
        ],
      ),
    );
  }

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      TransactionsNotifier.of(context).fetchTransactions();
      BalanceNotifier.of(context).fetchBalance();
    });
    super.initState();
  }

  Widget _transactionsList(BuildContext context) {
    print("[widget] rebuild transactions");

    return Consumer<TransactionsNotifier>(
      builder: (context, model, child) => model != null &&
              model.transactions != null
          ? ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.transactions.length,
              itemBuilder: (ctx, index) {
                final trx = model.transactions[index];

                return Container(
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      alignment: Alignment.centerLeft,
                      width: 42,
                      child: trx.from == SettingsNotifier.of(context).accountName
                          ? Icon(
                              Icons.arrow_upward,
                              color: Colors.redAccent,
                            )
                          : Icon(
                              Icons.arrow_downward,
                              color: CustomColors.green,
                            ),
                    ),
                    title: Text(
                      "${trx.from} -> ${trx.to}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(trx.memo),
                    trailing: Container(
                        child: Text(
                      trx.quantity,
                      style: TextStyle(
                        fontSize: 15,
                        color: trx.from == SettingsNotifier.of(context).accountName
                            ? Colors.redAccent
                            : CustomColors.green,
                      ),
                    )),
                  ),
                );
              })
          : Center(
              child: LinearProgressIndicator(
                backgroundColor: CustomColors.green,
              ),
            ),
    );
  }

  Widget _titleText(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: CustomColors.green),
        ),
      ),
      margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontFamily: "worksans",
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardList() {
    print("[widget] rebuild dashboard");

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: ListTile(
            leading: Container(
              width: 42,
              child: Icon(
                Icons.account_balance_wallet,
                color: CustomColors.green,
              ),
            ),
            title: Consumer<BalanceNotifier>(
              builder: (context, model, child) =>
                  model != null && model.balance != null
                      ? Text(model.balance.quantity)
                      : LinearProgressIndicator(),
            ),
            subtitle: Text("Available balance"),
            trailing: SeedsButton("Transfer", () {
              NavigationService.of(context).navigateTo(Routes.transfer);
            }),
          ),
        ),
        ListTile(
          leading: Container(
            width: 42,
            child: Icon(
              Icons.event_note,
              color: CustomColors.green,
            ),
          ),
          title: Text("0 VOICE"),
          subtitle: Text("Voice balance"),
          trailing: SeedsButton("Vote", () {
              NavigationService.of(context).navigateTo(Routes.proposals);
          }),
        ),
        ListTile(
          leading: Container(
            width: 42,
            child: Icon(
              Icons.people,
              color: CustomColors.green,
            ),
          ),
          title: Text("75.0000 SEEDS"),
          subtitle: Text("Invites balance"),
          trailing: SeedsButton("Invite", () {
              NavigationService.of(context).navigateTo(Routes.invites);
          }),
        ),
        SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.lightGrey19,
                    offset: Offset(0, 0),
                    blurRadius: 0.1,
                    spreadRadius: 0.1,
                  )
                ]),
            child: InkWell(
              onTap: () {
                NavigationService.of(context).navigateTo(Routes.proposals);
              },
              child: ListTile(
                leading: Container(
                  width: 42,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.star_half,
                    color: CustomColors.green,
                  ),
                ),
                title: Text(
                  "Urgent proposals waiting for your approval",
                  style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
