import 'package:flutter/material.dart';

class ShowTransactionSuccess {
  final String amount;
  final String toImage;
  final String toName;
  final String toAccount;
  final String fromImage;
  final String fromName;
  final String fromAccount;
  final String transactionId;

  ShowTransactionSuccess({
    @required this.amount,
    this.toImage,
    this.toName,
    @required this.toAccount,
    this.fromImage,
    this.fromName,
    @required this.fromAccount,
    @required this.transactionId,
  });

  ShowTransactionSuccess.withoutServerUserData({
    String amount,
    String toAccount,
    String fromAccount,
    String transactionId,
  }) : this(amount: amount, toAccount: toAccount, fromAccount: fromAccount, transactionId: transactionId);
}
