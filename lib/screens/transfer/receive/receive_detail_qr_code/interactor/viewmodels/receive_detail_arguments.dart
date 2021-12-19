import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';

class ReceiveDetailArguments {
  final String? description;
  final String invoiceLink;
  final Uri? invoiceLinkUri;
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;

  const ReceiveDetailArguments({
    required this.tokenAmount,
    required this.fiatAmount,
    required this.invoiceLink,
    required this.invoiceLinkUri,
    this.description,
  });
}
