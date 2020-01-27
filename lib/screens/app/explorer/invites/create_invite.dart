import 'package:flutter/material.dart';
import 'package:seeds/widgets/transaction_form.dart';

class CreateInvite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      image: Image.asset("assets/images/explorer2.png"),
      beneficiary: "join.seeds",
      title: "Invite friend",
      type: TransactionType.seedsTransfer,
    );
  }
}