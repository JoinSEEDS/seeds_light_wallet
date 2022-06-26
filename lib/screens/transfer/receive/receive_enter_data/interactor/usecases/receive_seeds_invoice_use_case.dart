import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/invoice_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';
import 'package:seeds/utils/result_extension.dart';

class ReceiveSeedsInvoiceUseCase extends InputUseCase<ReceiveInvoiceResponse, _Input> {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final CreateFirebaseDynamicLinkUseCase _firebaseDynamicLinkUseCase = CreateFirebaseDynamicLinkUseCase();

  static _Input input({required TokenDataModel tokenAmount, String? memo}) =>
      _Input(tokenAmount: tokenAmount, memo: memo);

  @override
  Future<Result<ReceiveInvoiceResponse>> run(_Input input) async {
    final Result<String> invoice = await _invoiceRepository.createInvoice(
      tokenAmount: input.tokenAmount,
      accountName: settingsStorage.accountName,
      tokenContract: TokenModel.fromId(input.tokenAmount.id!).contract,
      memo: input.memo,
    );

    if (invoice.isError) {
      return Result.error(invoice.asError!.error);
    } else {
      final Result<Uri> decodedInvoice =
          await _firebaseDynamicLinkUseCase.createDynamicLink(invoiceTargetLink, invoice.valueOrCrash);

      return Result.value(ReceiveInvoiceResponse(invoice.valueOrCrash, decodedInvoice.valueOrNull));
    }
  }
}

class _Input {
  final TokenDataModel tokenAmount;
  final String? memo;

  _Input({required this.tokenAmount, required this.memo});
}

class ReceiveInvoiceResponse {
  final String invoice;
  final Uri? invoiceDeepLink;

  ReceiveInvoiceResponse(this.invoice, this.invoiceDeepLink);
}
