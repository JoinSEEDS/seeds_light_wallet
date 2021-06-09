class ReceiveDetailArguments {
  final String? description;
  final String InvoiceLink;
  final String ReceiveTotalSeeds;
  final String ReceiveTotalFiat;

  ReceiveDetailArguments(
      {required this.ReceiveTotalSeeds, required this.ReceiveTotalFiat, required this.InvoiceLink, this.description});
}
