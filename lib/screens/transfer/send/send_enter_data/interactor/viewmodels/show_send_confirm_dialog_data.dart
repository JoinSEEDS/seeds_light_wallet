import 'package:seeds/domain-shared/page_command.dart';

class ShowSendConfirmDialog extends PageCommand {
  final String amount;
  final String? fiatAmount;
  final String fiatCurrency;
  final String tokenSymbol;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;

  ShowSendConfirmDialog({
    required this.amount,
    required this.tokenSymbol,
    required this.fiatCurrency,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
  });
}
