import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/v2/screens/wallet/components/wallet_header.dart';
import 'package:seeds/v2/screens/wallet/components/wallet_middle.dart';
import 'components/wallet_bottom.dart';
import 'interactor/viewmodels/wallet_events.dart';
import 'interactor/wallet_bloc.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';

/// Wallet SCREEN
class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc()..add(LoadWallet(userName: SettingsNotifier.of(context).accountName, transactions: TransactionsNotifier.of(context))),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: ListView(
          children: <Widget>[
            WalletHeader(),
            SizedBox(height: 20),
            WalletMiddle(),
            SizedBox(height: 20),
            WalletBottom(),
          ],
        ),
      ),
    );
  }
}


