import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendPageState extends Equatable {
  final PageState pageState;
  final String error;

  const SendPageState({
    @required this.pageState,
    this.error
  });

  @override
  List<Object> get props => [pageState];

  SendPageState copyWith({
    PageState pageState, String error
  }) {
    return SendPageState(
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
    );
  }

  factory SendPageState.initial() {
    return const SendPageState(pageState: PageState.initial);
  }
}
