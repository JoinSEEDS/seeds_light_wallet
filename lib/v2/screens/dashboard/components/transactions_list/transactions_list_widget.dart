import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/viewmodels/transactions_list_bloc.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/interactor/viewmodels/transactions_list_state.dart';
import 'package:seeds/v2/screens/dashboard/components/transactions_list/transaction_info_card.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/wallet_bloc.dart';
import 'package:shimmer/shimmer.dart';

class TransactionsListWidget extends StatefulWidget {
  @override
  _TransactionsListWidgetState createState() => _TransactionsListWidgetState();
}

class _TransactionsListWidgetState extends State<TransactionsListWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<TransactionsListBloc>(
      create: (_) => TransactionsListBloc()..add(LoadTransactionsListEvent()),
      child: BlocListener<WalletBloc, WalletState>(
          listenWhen: (context, state) => state.pageState == PageState.loading,
          listener: (context, state) {
            BlocProvider.of<TransactionsListBloc>(context).add(LoadTransactionsListEvent());
          },
          child: BlocBuilder<TransactionsListBloc, TransactionsListState>(
            builder: (context, state) {
              if (state.isLoadingNoData) {
                return Column(
                  children: [for (var i = 0; i < 5; i++) loadingShimmer()],
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return buildTransaction(settingsStorage.accountName, state.transactions[index]);
                  },
                  itemCount: state.transactions.length,
                );
              }
            },
          )),
    );
  }

  Widget buildTransaction(String userAccount, TransactionModel model) {
    String displayAccount = model.to == userAccount ? model.from : model.to;

    return TransactionInfoCard(
      callback: () {
        // TODO(n13): Implement callback - show tx detail
        print("Not implemented");
      },
      profileAccount: displayAccount,
      timestamp: model.timestamp,
      amount: model.quantity,
      incoming: userAccount == model.to,
    );
  }

  Widget loadingShimmer() => Shimmer.fromColors(
        baseColor: AppColors.grey1,
        highlightColor: AppColors.grey2,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 44,
                color: AppColors.black50,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              ),
            ),
          ],
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
