import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/viewmodels/auth.dart';
import 'package:seeds/viewmodels/balance.dart';
import 'package:seeds/widgets/reactive_widget.dart';
import 'package:seeds/widgets/seeds_button.dart';

import 'package:provider/provider.dart';
import 'package:seeds/viewmodels/transactions.dart';

class Home extends StatefulWidget {
  final Function movePage;

  Home(this.movePage);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  bool get wantKeepAlive => false;

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _titleText("Welcome, ${Provider.of<AuthModel>(context, listen: false).accountName}"),
          _dashboardList(),
          _titleText("Latest transactions"),
          _transactionsList(context)
        ],
      ),
    );
  }

  @override
  initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<TransactionsModel>(context, listen: false)
    //       .fetchTransactions();
    // });
    super.initState();
  }

  Widget _transactionsList(BuildContext context) {
    print("rebuild transactions widget");

    return ReactiveWidget(
      onModelReady: (model) => model.fetchTransactions(),
      model: TransactionsModel(
        auth: Provider.of<AuthModel>(context),
        http: Provider.of<HttpService>(context),
      ),
      builder: (context, model, child) =>
          model != null && model.transactions != null
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
                          child: trx.from == Provider.of<AuthModel>(context, listen: false).accountName
                              ? Icon(
                                  Icons.arrow_upward,
                                  color: Colors.redAccent,
                                )
                              : Icon(
                                  Icons.arrow_downward,
                                  color: CustomColors.Green,
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
                            color: trx.from == Provider.of<AuthModel>(context, listen: false).accountName
                                ? Colors.redAccent
                                : CustomColors.Green,
                          ),
                        )),
                      ),
                    );
                  })
              : Center(
                  child: LinearProgressIndicator(
                    backgroundColor: CustomColors.Green,
                  ),
                ),
    );
  }

  Widget _titleText(String title) {
    return Container(
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
    print("rebuild dashboard");

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
                color: CustomColors.Green,
              ),
            ),
            title: ReactiveWidget(
              onModelReady: (model) => model.fetchBalance(),
              model: BalanceModel(
                http: Provider.of<HttpService>(context),
                auth: Provider.of<AuthModel>(context, listen: false),
              ),
              builder: (context, model, child) =>
                  model != null && model.balance != null
                      ? Text(model.balance.quantity)
                      : LinearProgressIndicator(),
            ),
            subtitle: Text("Available balance"),
            trailing: SeedsButton("Transfer", () => {widget.movePage(1)}),
          ),
        ),
        ListTile(
            leading: Container(
              width: 42,
              child: Icon(
                Icons.settings_backup_restore,
                color: CustomColors.Green,
              ),
            ),
            title: Text("25.0000 SEEDS"),
            subtitle: Text("Planted amount"),
            trailing: SeedsButton("Harvest", () => widget.movePage(2))),
        ListTile(
          leading: Container(
            width: 42,
            child: Icon(
              Icons.people,
              color: CustomColors.Green,
            ),
          ),
          title: Text("75.0000 SEEDS"),
          subtitle: Text("Gifted amount"),
          trailing: SeedsButton("Friends", () => widget.movePage(3)),
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
                  color: CustomColors.LightGrey19,
                  offset: Offset(0, 0),
                  blurRadius: 0.1,
                  spreadRadius: 0.1,
                )
              ]),
          child: ListTile(
            leading: Container(
              width: 42,
              alignment: Alignment.center,
              child: Icon(
                Icons.star_half,
                color: CustomColors.Green,
              ),
            ),
            title: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("30 %"),
                    Text("Transactions"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("50 %"),
                    Text("Planting"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("80 %"),
                    Text("Reputation"),
                  ],
                ),
                Column(
                  children: <Widget>[Text("25%"), Text("Community")],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
