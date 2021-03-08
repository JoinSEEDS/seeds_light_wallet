import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/local/models/currency.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATES
class SetCurrencyState extends Equatable {
  final PageState pageState;
  final String currentQuery;
  final List<Currency> availableCurrencies;
  final String errorMessage;

  const SetCurrencyState({
    @required this.pageState,
    this.currentQuery,
    this.availableCurrencies,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        currentQuery,
        availableCurrencies,
        errorMessage,
      ];

  SetCurrencyState copyWith({
    PageState pageState,
    String currentQuery,
    List<Currency> availableCurrencies,
    String errorMessage,
  }) {
    return SetCurrencyState(
      pageState: pageState ?? this.pageState,
      currentQuery: currentQuery ?? this.currentQuery,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SetCurrencyState.initial() {
    return const SetCurrencyState(
      pageState: PageState.initial,
      currentQuery: null,
      availableCurrencies: null,
      errorMessage: null,
    );
  }
}
