import 'package:seeds/datasource/local/models/eos_transaction.dart';

class SendConfirmationArguments {
  final EOSTransaction transaction;

  SendConfirmationArguments({
    required this.transaction,
  });
}
