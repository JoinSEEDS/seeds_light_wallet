import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/page_command.dart';

class ShowSendConfirmDialog extends PageCommand {
  final String amount;
  final String currency;
  final String? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;

  ShowSendConfirmDialog({
    required this.amount,
    required this.currency,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
  });
}
