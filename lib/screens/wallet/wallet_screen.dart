import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/tokens_cards.dart';
import 'package:seeds/screens/wallet/components/transactions_list/transactions_list.dart';
import 'package:seeds/screens/wallet/components/wallet_appbar.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => WalletBloc()..add(const OnLoadWalletData()),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, _) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
              BlocProvider.of<WalletBloc>(context).add(const OnLoadWalletData());
            },
            child: Scaffold(
              appBar: const WalletAppBar(),
              body: ListView(
                children: [
                  const SizedBox(height: 15),
                  const TokenCards(),
                  const SizedBox(height: 20),
                  const TransactionsList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
