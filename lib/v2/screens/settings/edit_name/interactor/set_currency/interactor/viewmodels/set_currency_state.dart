import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SetCurrencyState extends Equatable {
  final PageState pageState;
  final FiatRateModel fiatRateModel;
  final String errorMessage;

  SetCurrencyState({
    @required this.pageState,
    this.fiatRateModel,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        fiatRateModel,
        errorMessage,
      ];

  SetCurrencyState copyWith({
    PageState pageState,
    FiatRateModel fiatRateModel,
    String errorMessage,
  }) {
    return SetCurrencyState(
      pageState: pageState ?? this.pageState,
      fiatRateModel: fiatRateModel ?? this.fiatRateModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SetCurrencyState.initial() {
    return SetCurrencyState(
      pageState: PageState.initial,
      fiatRateModel: null,
      errorMessage: null,
    );
  }
}
