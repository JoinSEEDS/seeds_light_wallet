import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/available_balance_row/interactor/available_balance_bloc.dart';
import '../balance_row.dart';
import 'interactor/viewmodels/available_balance_state.dart';

/// Available Amount
///
/// Used to show account available balance
class AvailableBalanceRow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
      create: (BuildContext context) => AvailableBalanceBloc(rates),
      child: BlocBuilder<AvailableBalanceBloc, AvailableBalanceState>(
          builder: (BuildContext context, AvailableBalanceState state) {
        return BalanceRow(label: "Available Balance", seedsAmount: state.seedsAmount, fiatAmount: state.fiatAmount);
      }),
    );
  }
}
