class SendConfirmationArguments {
  final String account;
  final String name;
  final Map<String, dynamic> data;
  final int pops;

  SendConfirmationArguments({
    required this.account,
    required this.name,
    required this.data,
    required this.pops,
  });
}
