import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/transfer.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_card.dart';

import 'package:provider/provider.dart';
import 'package:seeds/widgets/transaction_dialog.dart';

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
              buildNotification('Urgent proposals wating for your approval'),
              buildHeader(),
              // Row(
              //   children: <Widget>[
              //     Consumer<VoiceNotifier>(
              //       builder: (context, model, child) => buildBalance(
              //         'Voice balance',
              //         "${model?.balance?.amount ?? 0}",
              //         'Proposals',
              //         onVote,
              //       ),
              //     ),
              //     Padding(padding: EdgeInsets.only(left: 7)),
              //     Consumer<PlantedNotifier>(
              //       builder: (context, model, child) => buildBalance(
              //         'Planted balance',
              //         "${model?.balance?.quantity ?? 0}",
              //         'Harvest',
              //         onInvite,
              //       ),
              //     ),
              //   ],
              // ),
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
    //NavigationService.of(context).navigateTo(Routes.transfer);
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx){ return Transfer();}));
  }

  void onVote() {
    NavigationService.of(context).navigateTo(Routes.proposals);
  }

  void onInvite() {
    NavigationService.of(context).navigateTo(Routes.invites);
  }

  void onTransaction(TransactionModel model) {
    //TODO: show correctly in fullscreen (above bottom tabs and tapbar)
    showModalBottomSheet(
      context: context,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (BuildContext context){
        return TransactionDialog(
          transaction: model
        );
      }
    );
  }

  void onClose() {}

  Widget buildNotification(String text) {
    return InkWell(
      onTap: (onVote),
      child: Container(
        margin: EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.orange),
            color: AppColors.orange.withOpacity(0.16)),
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
            )),
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
                        colors: AppColors.gradient),
                    borderRadius: BorderRadius.circular(8)),
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
                    Consumer<BalanceNotifier>(
                      builder: (context, model, child) =>
                          model != null && model.balance != null
                              ? Text(
                                  '${model.balance.quantity}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                )
                              : LinearProgressIndicator(),
                    ),
                    EmptyButton(
                      width: width * 0.5,
                      title: 'Transfer',
                      color: Colors.white,
                      onPressed: (onTransfer),
                    )
                  ],
                ))));
  }

  Widget buildBalance(
      String title, String balance, String buttonTitle, Function onPressed) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(bottom: 7, top: 7),
      child: MainCard(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(color: AppColors.grey, fontSize: 14),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Text(
                balance, // balance.toStringAsFixed(2),
                style: TextStyle(fontSize: 20),
              ),
              Padding(padding: EdgeInsets.only(top: 12)),
              EmptyButton(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 28,
                  title: buttonTitle,
                  onPressed: onPressed,
                  fontSize: 14)
            ],
          )),
    ));
  }

  Widget buildTransaction(TransactionModel model) {
     final type = TransactionType.income;
     final fullName = 'fddf as';
     final imageUrl = null;
     return InkWell(
        onTap: ()=> onTransaction(model),
        child: Column(children: [
          Divider(height: 22),
          Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 10),
                        child: Icon(type == TransactionType.income ? Icons.arrow_downward : Icons.arrow_upward,
                          color: type == TransactionType.income ? AppColors.green : AppColors.red,
                        ),
                      ),
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
                              tag: 'avatar#${model.from}')),
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
                                                fontSize: 15),
                                          ),
                                        ),
                                        tag: 'nickname${model.from}'),
                                    Hero(
                                        child: Container(
                                          child: Text(
                                            model.from,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 13),
                                          ),
                                        ),
                                        tag: 'account#${model.from}}'),
                                  ])))
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      children: <Widget>[
                        Text(type == TransactionType.income ? '+ ' : '-' ,
                          style: TextStyle(
                            color: type == TransactionType.income ? AppColors.green : AppColors.red,
                            fontSize: 16
                          ),
                        ),
                        Text(model.quantity,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                          ),
                        )
                      ],
                    )
                  )
                ],
              ))
        ]));
  }

  Widget buildTransactions() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: 7, top: 15),
      child: MainCard(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 3, left: 15, right: 15),
              child: Text(
                'Latest transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ),
            Consumer<TransactionsNotifier>(
              builder: (context, model, child) =>
                  model != null && model.transactions != null
                      ? Column(
                        children: <Widget>[
                          ...model.transactions.map((trx) {
                            // TODO: actual model
                            return buildTransaction(trx);
                          }).toList()
                        ],
                      )
                      : Center(
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.green,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
