import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_state.dart';
import 'package:seeds/v2/screens/wallet/interactor/wallet_bloc.dart';
import 'package:seeds/widgets/read_times_tamp.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seeds/utils/string_extension.dart';



/// Wallet Bottom
class WalletBottom extends StatelessWidget {
  const WalletBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      return Column(
        children: <Widget>[transactionsHeader(context),buildTransactions(context) ],
      );
    });
  }
}

Widget transactionsHeader(context) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(child: Text('Latest Transactions', style: Theme.of(context).textTheme.button)),
      Text(
        'View All',
        style: TextStyle(color: AppColors.canopy),
      )
    ]),
  );
}

Widget buildTransactions(context) {
  return Column(
    children: <Widget>[
      Consumer<TransactionsNotifier>(
        builder: (context, model, child) => model != null && model.transactions != null
            ? Column(
          children: <Widget>[
            ...model.transactions.map((trx) {
              return buildTransaction(trx, context);
            }).toList()
          ],
        )
            : Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 16,
                color: Colors.black,
                margin: EdgeInsets.only(left: 10, right: 10),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget displayTransactionTimeCard(model, context){
  return Text(readTimestamp(model.timestamp), style: Theme.of(context).textTheme.subtitle2);
}

Widget diplayTranscationType(context){
  return Text('SEEDS',style: Theme.of(context).textTheme.subtitle2);
}


Widget buildTransaction(TransactionModel model , context) {
  String userAccount = SettingsNotifier.of(context).accountName;

  TransactionType type = model.to == userAccount ? TransactionType.income : TransactionType.outcome;

  String participantAccountName = type == TransactionType.income ? model.from : model.to;

  return FutureBuilder(
    future: MembersNotifier.of(context).getAccountDetails(participantAccountName),
    builder: (ctx, member) => member.hasData
        ? InkWell(
      //Needs to be implemented
      // onTap: () => onTransaction(transaction: model, member: member.data, type: type),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        child: Row(
          children: <Widget>[
            TransactionAvatar(
              size: 60,
              account: member.data.account,
              nickname: member.data.nickname,
              image: member.data.image,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              member.data.nickname,
                              style: Theme.of(context).textTheme.button,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                        SizedBox(width: 20),
                        Text(model.quantity.seedsFormatted, style: Theme.of(context).textTheme.button),
                        SizedBox(width: 4),
                        type == TransactionType.income
                            ? SvgPicture.asset('assets/images/wallet/arrow_up.svg', height: 16)
                            : SvgPicture.asset('assets/images/wallet/arrow_down.svg', height: 16),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(child: displayTransactionTimeCard(model, context)),
                        diplayTranscationType(context)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )
        : Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 16,
            color: Colors.white,
            margin: EdgeInsets.only(left: 10, right: 10),
          ),
        ],
      ),
    ),
  );
}