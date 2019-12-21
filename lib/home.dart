import 'dart:convert';

import 'package:flutter/material.dart';

import './customColors.dart';
import './seedsButton.dart';

import 'package:http/http.dart';

class Transaction {
  final String from;
  final String to;
  final String quantity;
  final String memo;

  Transaction(this.from, this.to, this.quantity, this.memo);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json["from"],
      json["to"],
      json["quantity"],
      json["memo"],
    );
  }
}

class Balance {
  final String quantity;

  Balance(this.quantity);

  factory Balance.fromJson(List<dynamic> json) {
    return Balance(json[0] as String);
  }
}

class HttpService {
  final String transactionsURL =
      "https://telos.caleos.io/v2/history/get_actions?account=testingseeds&filter=*%3A*&skip=0&limit=100&sort=desc";
  final String balanceURL =
      "https://telos.caleos.io/v1/chain/get_currency_balance";

  Future<List<Transaction>> getTransactions() async {
    Response res = await get(transactionsURL);

    print('get transactions');

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> transfers = body["actions"].where((dynamic item) {
        return item["act"]["account"] == "token.seeds" &&
            item["act"]["data"] != null &&
            item["act"]["data"]["from"] != null;
      }).toList();

      List<Transaction> transactions = transfers
          .map((item) => Transaction.fromJson(item["act"]["data"]))
          .toList();

      return transactions;
    } else {
      print("Cannot fetch transactions...");

      return [];
    }
  }

  Future<Balance> getBalance() async {
    String request =
        '{"code":"token.seeds","account":"testingseeds","symbol":"SEEDS"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      Balance balance = Balance.fromJson(body);

      return balance;
    } else {
      print("Cannot fetch balance...");

      return Balance("0.0000 SEEDS");
    }
  }
}

class Home extends StatelessWidget {
  final Function movePage;

  final HttpService httpService = HttpService();

  Home(this.movePage);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _titleText("Welcome, testingseeds"),
          _dashboardList(),
          _titleText("Latest transactions"),
          _transactionsList()
        ],
      ),
    );
  }

  Widget _transactionsList() {
    return FutureBuilder(
      future: httpService.getTransactions(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        if (snapshot.hasData) {
          List<Transaction> transactions = snapshot.data;

          return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final trx = transactions[index];

                return Container(
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      alignment: Alignment.centerLeft,
                      width: 42,
                      child: trx.from == "testingseeds"
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
                        color: trx.from == "testingseeds"
                            ? Colors.redAccent
                            : CustomColors.Green,
                      ),
                    )),
                  ),
                );
              });
        } else {
          return Center(
            child: LinearProgressIndicator(
              backgroundColor: CustomColors.Green,

            ),
          );
        }
      },
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
            title: FutureBuilder(
              future: httpService.getBalance(),
              builder: (BuildContext context, AsyncSnapshot<Balance> snapshot) {
                print(snapshot);
                if (snapshot.hasData) {
                  return Text(snapshot.data.quantity);
                } else {
                  return LinearProgressIndicator();
                }
              },
            ),
            subtitle: Text("Available balance"),
            trailing: SeedsButton("Transfer", () => {
              movePage(1)
            }),
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
            trailing: SeedsButton("Harvest", () => movePage(2))),
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
          trailing: SeedsButton("Friends", () => movePage(3)),
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
              child: Icon(
                Icons.star_half,
                color: CustomColors.Green,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("30 %"),
                    Text("Activity"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("50 %"),
                    Text("Staking"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("80 %"),
                    Text("Reputation"),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
