import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/screens/app/ecosystem/atm/atm_offer.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:shimmer/shimmer.dart';

class Atm extends StatefulWidget {
  Atm({Key key}) : super(key: key);

  @override
  _Atm createState() => _Atm();
}

class _Atm extends State<Atm> {
  final plantController = TextEditingController(text: '1');

  bool transactionSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTransactionForm(),
      ],
    );
  }

  Widget buildTransactionForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              WithTitle(
                title: "HELLO",
                child: AtmOffer(
                  name: "USD",
                  color: AppColors.blue.withOpacity(0.3),
                  exchangeRate: "0.123",
                ),
              ),
              buildTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTransactions() {
    List<TransactionModel> transactions = [
      TransactionModel("astoryteller", "illumination", "9", "memo", "123", "trxId"),
      TransactionModel("illumination", "astoryteller", "18", "memo", "123", "trxId"),
    ];
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
            Column(
              children: <Widget>[
                ...transactions.take(2).map((trx) {
                  return buildTransaction(trx);
                }).toList()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransaction(TransactionModel model) {
    String userAccount = SettingsNotifier.of(context).accountName;

    TransactionType type = model.to == userAccount
      ? TransactionType.income
      : TransactionType.outcome;

    String participantAccountName =
    type == TransactionType.income ? model.from : model.to;

    return FutureBuilder(
      future:
      MembersNotifier.of(context).getAccountDetails(participantAccountName),
      builder: (ctx, member) => member.hasData
        ? InkWell(
        onTap: () {
          debugPrint("onTap");
        },
        child: Column(
          children: [
            Divider(height: 22),
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 10),
                          child: Icon(
                            type == TransactionType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                            color: type == TransactionType.income
                              ? AppColors.green
                              : AppColors.red,
                          ),
                        ),
                        TransactionAvatar(
                          size: 40,
                          account: member.data.account,
                          nickname: member.data.nickname,
                          image: member.data.image,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin:
                            EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    member.data.nickname,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    member.data.account,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 13),
                                  ),
                                ),
                              ])))
                      ],
                    )),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          type == TransactionType.income ? '+ ' : '-',
                          style: TextStyle(
                            color: type == TransactionType.income
                              ? AppColors.green
                              : AppColors.red,
                            fontSize: 16),
                        ),
                        Text(
                          model.quantity,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                        )
                      ],
                    ))
                ],
              ),
            ),
          ],
        ),
      )
        : Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 16,
              width: 320,
              color: Colors.white,
              margin: EdgeInsets.only(left: 10, right: 10),
            ),
          ],
        ),
      ),
    );
  }

}

class WithTitle extends StatelessWidget {

  final String title;
  final Widget child;

  WithTitle({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

