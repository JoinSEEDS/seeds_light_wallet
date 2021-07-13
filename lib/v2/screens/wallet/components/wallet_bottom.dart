import 'package:flutter/material.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/transactions_list_widget.dart';

class WalletBottom extends StatelessWidget {
  const WalletBottom();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(child: Text('Transactions History'.i18n, style: Theme.of(context).textTheme.headline7LowEmphasis)),
          ]),
        ),
        const SizedBox(
          height: 16,
        ),
        TransactionsListWidget()
      ],
    );
  }
}
