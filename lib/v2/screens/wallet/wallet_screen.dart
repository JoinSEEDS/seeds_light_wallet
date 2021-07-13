import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/wallet/components/receive_send_buttons.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/tokens_cards.dart';
import 'package:seeds/v2/screens/wallet/components/wallet_appbar.dart';
import 'package:seeds/v2/screens/wallet/components/wallet_bottom.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

/// Wallet SCREEN
class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

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
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
              BlocProvider.of<WalletBloc>(context).add(const OnLoadWalletData());
            },
            child: Scaffold(
              appBar: const WalletAppBar(),
              body: ListView(
                // TODO(n13): Use exact measurements from figma
                children: <Widget>[
                  const SizedBox(height: 15),
                  const TokenCards(),
                  const SizedBox(height: 20),
                  const ReceiveSendButtons(),
                  const SizedBox(height: 20),
                  const WalletBottom(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
