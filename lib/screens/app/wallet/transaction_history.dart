import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/reactive_widget.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum  TransactionType { income, outcome }
const TransactionHistoryElements = 100;

class TransactionFilter {
  static const today     = 0;
  static const last2day  = 1;
  static const lastweek  = 2;
  static const lastmonth = 3;
  static const all       = 4;
}

class TransactionHistory extends StatefulWidget {
  @override
  TransactionHistoryState createState() => TransactionHistoryState();
}

class TransactionHistoryState extends State<TransactionHistory> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime today  = new DateTime.now();
  DateTime lastTransactionDate  = new DateTime.now();
  DateTime firstTransactionDate = new DateTime.now();
  String todayTransactionDay = '';
  bool _searching = false;

  Choice _selectedChoice = choices[0];

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
      print("Transaction period: ${_selectedChoice.title}");
      todayTransactionDay = dateFormat.format(lastTransactionDate);
      if (_selectedChoice.index == TransactionFilter.all) {//--all
          _searching = true;
          Future.delayed(Duration.zero).then((_) {
              TransactionsNotifier.of(context).fetchTransactions(TransactionHistoryElements);
              _searching = false;
            });
      }
    });
  }
  
  String _getFilterTitle() {
    var dateRangTitles = '';
    lastTransactionDate = today;
    switch(_selectedChoice.index) { 
          case TransactionFilter.today: { //--today
              dateRangTitles = dateFormat.format(today); 
          } 
          break;           
          case TransactionFilter.last2day: { //--Last 2 Days 
            firstTransactionDate = today.add(new Duration(days: -2));         
          } 
          break; 
          case TransactionFilter.lastweek: { //--last week  
            firstTransactionDate = today.add(new Duration(days: -7));              
          } 
          break; 
          case TransactionFilter.lastmonth: { //--last month  
            firstTransactionDate = today.add(new Duration(days: -30));              
          } 
          break;
          case TransactionFilter.all: { //--all
            firstTransactionDate = today.add(new Duration(days: -180));              
          } 
          break;      
          default: { 
             dateRangTitles =''  ;
          }
          break; 
    }
    if (_selectedChoice.index != TransactionFilter.today) {
        dateRangTitles = 'From '+dateFormat.format(firstTransactionDate)+ ' To '+dateFormat.format(lastTransactionDate);         
    }
    return dateRangTitles;
  }

  @override
  Widget build(BuildContext context) {
    @override
    initState() {
      firstTransactionDate = lastTransactionDate.add(new Duration(days: -30));
      todayTransactionDay = dateFormat.format(lastTransactionDate);
      TransactionsNotifier.of(context).fetchTransactions(TransactionHistoryElements);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Transactions history",
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        
        actions: <Widget>[
          PopupMenuButton<Choice>(
              icon: Icon(Icons.more_vert, color: Colors.green),
              color: Colors.green[100],
              onSelected: _select,
              itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title)
                  );
                }).toList();
              },
            ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: AppColors.green),
                ),
              ),
              margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                
                ],
              ),
            ),
         buildTransactions(context),
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
      String date, List<TransactionModel> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        _searching == true?
         LinearProgressIndicator(
                            backgroundColor: AppColors.green,
                          ):
        Column(
          children: <Widget>[
            ...transactions.map((trx) {
              return buildTransaction(
                  trx.to, trx.quantity, TransactionType.income);
            }).toList()
          ],
        )
      ],
    );
  }

  Widget buildTransactions(context) {
    final width = MediaQuery.of(context).size.width;
    var   todayTransactionDay = dateFormat.format(lastTransactionDate);
    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: 7, top: 7),
      child: MainCard(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                            _getFilterTitle(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ), 
              ),
            ),
           
            Consumer<TransactionsNotifier>(
              builder: (context, model, child) =>
                  model != null && model.transactions != null
                      ? buildDateTransactions(todayTransactionDay, model.transactions)
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

//----Actions menu---
class Choice {
  const Choice({this.title, this.index, this.icon});

  final int index;
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(index:TransactionFilter.today,   title: 'Today',       icon: Icons.view_day),
  const Choice(index:TransactionFilter.last2day,title: 'Last 2 Days', icon: Icons.date_range),
  const Choice(index:TransactionFilter.lastweek,title: 'Last week',   icon: Icons.view_week),
  const Choice(index:TransactionFilter.lastmonth,title: 'Last month', icon: Icons.view_agenda),
  const Choice(index:TransactionFilter.all,      title: 'All',        icon: Icons.all_inclusive),
];
