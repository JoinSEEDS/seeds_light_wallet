class ShowTransactionSuccess {
  final String amount;
  final String currency;
  final String? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? fromImage;
  final String? fromName;
  final String fromAccount;
  final String transactionId;

  ShowTransactionSuccess({
    required this.amount,
    required this.currency,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.fromImage,
    this.fromName,
    required this.fromAccount,
    required this.transactionId,
  });

  ShowTransactionSuccess.withoutServerUserData({
    required String amount,
    required String currency,
    required String toAccount,
    required String fromAccount,
    required String transactionId,
    String? fiatAmount,
  }) : this(
            amount: amount,
            currency: currency,
            toAccount: toAccount,
            fromAccount: fromAccount,
            transactionId: transactionId,
            fiatAmount: fiatAmount);
}
