import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;

  const SendConfirmationState({
    @required this.pageState,
  });

  @override
  List<Object> get props => [pageState];

  SendConfirmationState copyWith({
    PageState pageState
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState
    );
  }

  factory SendConfirmationState.initial() {
    return const SendConfirmationState(
      pageState: PageState.initial
    );
  }
}
