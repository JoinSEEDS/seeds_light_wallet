class ReceiveDetailArguments {
  final String? description;
  final String invoiceLink;
  final double receiveTotalSeeds;
  final double receiveTotalFiat;

  const ReceiveDetailArguments({
    required this.receiveTotalSeeds,
    required this.receiveTotalFiat,
    required this.invoiceLink,
    this.description,
  });
}
