import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATES
class SetCurrencyState extends Equatable {
  final PageState pageState;
  final String currentQuery;
  final FiatRateModel fiatRateModel;
  final List<String> currencyResult;
  final String errorMessage;

  const SetCurrencyState({
    @required this.pageState,
    this.currentQuery,
    this.fiatRateModel,
    this.currencyResult,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        currentQuery,
        fiatRateModel,
        currencyResult,
        errorMessage,
      ];

  SetCurrencyState copyWith({
    PageState pageState,
    String currentQuery,
    FiatRateModel fiatRateModel,
    List<String> currencyResult,
    String errorMessage,
  }) {
    return SetCurrencyState(
      pageState: pageState ?? this.pageState,
      currentQuery: currentQuery ?? this.currentQuery,
      fiatRateModel: fiatRateModel ?? this.fiatRateModel,
      currencyResult: currencyResult ?? this.currencyResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SetCurrencyState.initial() {
    return const SetCurrencyState(
      pageState: PageState.initial,
      currentQuery: null,
      fiatRateModel: null,
      currencyResult: null,
      errorMessage: null,
    );
  }
}
