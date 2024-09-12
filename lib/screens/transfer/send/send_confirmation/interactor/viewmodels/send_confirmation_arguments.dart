import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

class SendConfirmationArguments {
  final EOSTransaction transaction;
  final String? callback;
  final TransactionPageCommand? pageCommand;

  const SendConfirmationArguments({required this.transaction, this.callback, this.pageCommand});

  factory SendConfirmationArguments.from(ScanQrCodeResultData data) =>
      SendConfirmationArguments(transaction: data.transaction, callback: data.esr.callback);
}
