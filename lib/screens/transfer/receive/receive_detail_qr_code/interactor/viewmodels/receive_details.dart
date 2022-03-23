import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';

class ReceiveDetails {
  final String? memo;
  final String invoiceLink;
  final Uri? invoiceLinkUri;
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;

  const ReceiveDetails({
    this.memo,
    required this.invoiceLink,
    required this.invoiceLinkUri,
    required this.tokenAmount,
    required this.fiatAmount,
  });
}
