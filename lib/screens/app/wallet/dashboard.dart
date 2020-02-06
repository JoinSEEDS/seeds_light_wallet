import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:shimmer/shimmer.dart';

enum TransactionType { income, outcome }

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(17),
          child: Column(
            children: <Widget>[
              //buildNotification('Urgent proposals wating for your approval'),
              buildHeader(),
              Row(
                children: <Widget>[
                  Consumer<VoiceNotifier>(
                    builder: (context, model, child) => buildBalance(
                      'Voice balance',
                      "${model?.balance?.amount ?? 0}",
                      'Proposals',
                      onVote,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 7)),
                  Consumer<PlantedNotifier>(
                    builder: (context, model, child) => buildBalance(
                      'Planted balance',
                      "${model?.balance?.quantity ?? 0}",
                      'Harvest',
                      onInvite,
                    ),
                  ),
                ],
              ),
              buildTransactions()
            ],
          )),
    );
  }

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      TransactionsNotifier.of(context).fetchTransactions();
      BalanceNotifier.of(context).fetchBalance();
      VoiceNotifier.of(context).fetchBalance();
      PlantedNotifier.of(context).fetchBalance();
    });
    super.initState();
  }

  void onTransfer() {
    NavigationService.of(context).navigateTo(Routes.transfer);
  }

  void onVote() {
    NavigationService.of(context).navigateTo(Routes.proposals);
  }

  void onInvite() {
    NavigationService.of(context).navigateTo(Routes.invites);
  }

  void onClose() {}

  Widget buildNotification(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onVote,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.orange),
            color: AppColors.orange.withOpacity(0.16),
          ),
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.warning,
                color: AppColors.orange,
                size: 20,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 7),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.orange, fontSize: 14),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.close),
                onPressed: onClose,
                color: AppColors.orange,
                iconSize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.2,
      child: MainCard(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: AppColors.gradient,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Available balance',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Consumer<BalanceNotifier>(builder: (context, model, child) {
                return (model != null && model.balance != null)
                    ? Text(
                        '${model.balance.quantity}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.green[300],
                        highlightColor: Colors.blue[300],
                        child: Container(
                          width: 200.0,
                          height: 26,
                          color: Colors.white,
                        ),
                      );
              }),
              EmptyButton(
                width: width * 0.5,
                title: 'Transfer',
                color: Colors.white,
                onPressed: onTransfer,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBalance(
    String title,
    String balance,
    String buttonTitle,
    Function onPressed,
  ) {
    return Expanded(
      child: MainCard(
        margin: EdgeInsets.only(bottom: 7, top: 7),
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                balance, // balance.toStringAsFixed(2),
                style: TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: EmptyButton(
                height: 28,
                title: buttonTitle,
                onPressed: onPressed,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransaction(String name, String amount, TransactionType type) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Row(
                children: <Widget>[
                  type == TransactionType.income
                      ? Icon(
                          Icons.arrow_downward,
                          color: AppColors.green,
                          size: 17,
                        )
                      : Icon(
                          Icons.arrow_upward,
                          color: AppColors.orange,
                          size: 17,
                        ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              )),
              Row(
                children: <Widget>[
                  type == TransactionType.income
                      ? Text(
                          '+ ',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.green,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          '- ',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                  Text(
                    '$amount',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ]));
  }

  Widget buildDateTransactions(
    String date,
    List<TransactionModel> transactions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              date,
              style: TextStyle(fontSize: 14, color: AppColors.grey),
            )),
        Column(
          children: (transactions != null)
              ? transactions.map((trx) {
                  return buildTransaction(
                      trx.to, trx.quantity, TransactionType.income);
                }).toList()
              : List(1)
                  .map((_) => Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 16,
                              width: 160,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                            ),
                            Container(
                              height: 16,
                              width: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
        )
      ],
    );
  }

  Widget buildTransactions() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: 7, top: 7),
      child: MainCard(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Latest transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Consumer<TransactionsNotifier>(
              builder: (context, model, child) =>
                  buildDateTransactions('18.01.2020', model?.transactions),
            ),
          ],
        ),
      ),
    );
  }
}
