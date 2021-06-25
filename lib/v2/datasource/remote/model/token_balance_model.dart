import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/utils/double_extension.dart';

  class TokenBalanceModel {
    
    final TokenModel token;
    final BalanceModel? balance;
    final bool errorLoading;

    const TokenBalanceModel(this.token, this.balance, {this.errorLoading = false});

    String get displayQuantity => errorLoading || balance == null ? "..." : 
                balance!.quantity.seedsFormatted + " " + token.symbol;

  }