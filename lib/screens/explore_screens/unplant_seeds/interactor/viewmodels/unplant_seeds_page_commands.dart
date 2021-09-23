import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowUnplantSeedsSuccess extends PageCommand {
  final TokenDataModel unplantedInputAmount;
  final FiatDataModel unplantedInputAmountFiat;

  ShowUnplantSeedsSuccess(this.unplantedInputAmount, this.unplantedInputAmountFiat);
}
