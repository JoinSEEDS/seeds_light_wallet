class ReceiveDetailArguments {
  final String? description;
  final String invoiceLink;
  final String receiveTotalSeeds;
  final String receiveTotalFiat;

  const ReceiveDetailArguments({
    required this.receiveTotalSeeds,
    required this.receiveTotalFiat,
    required this.invoiceLink,
    this.description,
  });
}
