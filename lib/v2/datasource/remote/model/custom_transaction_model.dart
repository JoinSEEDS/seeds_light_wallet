import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_info_line_items.dart';

class CustomTransactionModel {
  final String account;
  final String action;
  final Map<String, dynamic> data;
  final String? transactionId;

  List<SendInfoLineItems> get lineItems =>
      data.entries.map((e) => SendInfoLineItems(label: e.key, text: e.value.toString())).toList();

  CustomTransactionModel({required this.account, required this.action, required this.data, this.transactionId});
  factory CustomTransactionModel.fromTxData(
      String account, String action, Map<String, dynamic> data, String transactionId) {
    return CustomTransactionModel(account: account, action: action, data: data, transactionId: transactionId);
  }
}
