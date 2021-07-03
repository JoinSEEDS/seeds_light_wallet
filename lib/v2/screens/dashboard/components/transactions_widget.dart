import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_events.dart';

class TransactionsWidget extends StatefulWidget {
  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsBloc>(
      create: (_) => TransactionsBloc()..add(LoadTransactionsEvent()),
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(),
        itemCount: 1,
      ),
    );
  }
}
