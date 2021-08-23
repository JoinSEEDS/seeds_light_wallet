import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowSendConfirmDialog extends PageCommand {
  final TokenDataModel amount;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;

  ShowSendConfirmDialog({
    required this.amount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
  });
}
