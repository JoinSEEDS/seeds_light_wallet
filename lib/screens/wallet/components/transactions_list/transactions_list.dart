import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/transaction_details_bottom_sheet.dart';
import 'package:seeds/screens/wallet/components/transactions_list/components/transaction_info_row.dart';
import 'package:seeds/screens/wallet/components/transactions_list/components/transaction_loading_row.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_bloc.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

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
            Expanded(
                child: Text(testnetMode ? 'Transactions TESTNET' : context.loc.walletTransactionHistory,
                    style: Theme.of(context).textTheme.headline7LowEmphasis)),
          ]),
        ),
        const SizedBox(height: 6),
        BlocProvider<TransactionsListBloc>(
          create: (_) => TransactionsListBloc()..add(const OnLoadTransactionsList()),
          child: BlocListener<WalletBloc, WalletState>(
            listenWhen: (_, current) => current.pageState == PageState.loading,
            listener: (context, state) {
              BlocProvider.of<TransactionsListBloc>(context).add(const OnLoadTransactionsList());
            },
            child: BlocConsumer<TransactionsListBloc, TransactionsListState>(
              listenWhen: (_, current) => current.pageCommand != null,
              listener: (context, state) {
                final pageCommand = state.pageCommand;
                BlocProvider.of<TransactionsListBloc>(context).add(const ClearTransactionListPageComand());
                if (pageCommand is ShowTransactionDetails) {
                  TransactionDetailsBottomSheet(pageCommand.transaction).show(context);
                }
              },
              builder: (context, state) {
                if (state.isLoadingNoData) {
                  return Column(children: [for (var i = 0; i < 5; i++) const TransactionLoadingRow()]);
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.transactions.length,
                    itemBuilder: (_, index) {
                      final account = settingsStorage.accountName;
                      final model = state.transactions[index];
                      return TransactionInfoRow(
                        key: Key(model.transactionId ?? "index_$index"),
                        onTap: () {
                          BlocProvider.of<TransactionsListBloc>(context)
                              .add(OnTransactionRowTapped(state.transactions[index]));
                        },
                        profileAccount: model.to == account ? model.from : model.to,
                        timestamp: model.timestamp,
                        amount: model.quantity,
                        incoming: account == model.to,
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
