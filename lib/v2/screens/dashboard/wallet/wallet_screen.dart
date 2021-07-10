import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/v2/screens/dashboard/tokens_cards/tokens_cards.dart';
import 'package:seeds/v2/screens/dashboard/transactions/transactions_list_widget.dart';
import 'package:seeds/v2/screens/dashboard/wallet/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/dashboard/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:seeds/v2/screens/dashboard/wallet/components/wallet_appbar.dart';

// Widgets to be moved to v2
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/receive_button.dart';
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/send_button.dart';

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
                  buildSendReceiveButton(context),
                  const SizedBox(height: 20),
                  walletBottom(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSendReceiveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(child: SendButton(onPress: () => NavigationService.of(context).navigateTo(Routes.transfer))),
        const SizedBox(width: 20),
        Expanded(
            child: ReceiveButton(
                onPress: () async => await NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen))),
      ]),
    );
  }

  Widget walletBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        transactionHeader(context),
        const SizedBox(
          height: 16,
        ),
        TransactionsListWidget()
      ],
    );
  }

  Widget transactionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(child: Text('Transactions History'.i18n, style: Theme.of(context).textTheme.headline7LowEmphasis)),
      ]),
    );
  }
}
