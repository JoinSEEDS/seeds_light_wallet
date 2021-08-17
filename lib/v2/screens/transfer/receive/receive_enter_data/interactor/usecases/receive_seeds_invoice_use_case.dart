import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/invoice_repository.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';

class ReceiveSeedsInvoiceUseCase {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  Future<Result> run({required double amount, String? memo}) {
    return _invoiceRepository.createInvoice(
        quantity: amount, accountName: settingsStorage.accountName, token: SeedsToken, memo: memo);
  }
}
