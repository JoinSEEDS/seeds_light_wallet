import 'package:flutter/material.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class TokenBalanceViewModel {
  final TokenModel token;
  final TokenDataModel? tokenData;
  final bool errorLoading;
  Color? dominantColor;

  const TokenBalanceViewModel(this.token, this.tokenData, {this.errorLoading = false});

  String get displayQuantity {
    if (errorLoading || tokenData == null) {
      return "...";
    } else {
      return tokenData!.amountStringWithSymbol();
    }
  }

  /// Return a display string like "35.00 USD", or "" if conversion is impossible
  String fiatValueString(RatesState rateState) {
    return tokenData?.fiatString(rateState) ?? "";
  }
}
