import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/components/transaction_info_card.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/components/transaction_loadign_card.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_bloc.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_state.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/bloc.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({Key? key}) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(children: [
            Expanded(child: Text('Transactions History'.i18n, style: Theme.of(context).textTheme.headline7LowEmphasis)),
          ]),
        ),
        const SizedBox(height: 6),
        BlocProvider<TransactionsListBloc>(
          create: (_) => TransactionsListBloc()..add(OnLoadTransactionsList()),
          child: BlocListener<WalletBloc, WalletState>(
            listenWhen: (_, current) => current.pageState == PageState.loading,
            listener: (context, state) {
              BlocProvider.of<TransactionsListBloc>(context).add(OnLoadTransactionsList());
            },
            child: BlocBuilder<TransactionsListBloc, TransactionsListState>(
              builder: (context, state) {
                if (state.isLoadingNoData) {
                  return Column(children: [for (var i = 0; i < 5; i++) const TransactionLoadingCard()]);
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.transactions.length,
                    itemBuilder: (_, index) {
                      var model = state.transactions[index];
                      return TransactionInfoCard(
                        callback: () {
                          // TODO(n13): Implement callback - show tx detail
                          print("Not implemented");
                        },
                        profileAccount: model.to == settingsStorage.accountName ? model.from : model.to,
                        timestamp: model.timestamp,
                        amount: model.quantity,
                        incoming: settingsStorage.accountName == model.to,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
