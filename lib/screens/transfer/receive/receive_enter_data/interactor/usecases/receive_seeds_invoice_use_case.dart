import 'package:async/async.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/invoice_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class ReceiveSeedsInvoiceUseCase {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  Future<Result> run({required TokenDataModel tokenAmount, String? memo}) {
    return _invoiceRepository.createInvoice(
      tokenAmount: tokenAmount,
      accountName: settingsStorage.accountName,
      token: TokenModel.fromSymbol(tokenAmount.symbol),
      memo: memo,
    );
  }
}
