import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_info_line_items.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final String account;
  final String name;
  final List<SendInfoLineItems> lineItems;

  const SendConfirmationState({
    @required this.pageState,
    this.account,
    this.name,
    this.lineItems,
  });

  @override
  List<Object> get props => [pageState];

  SendConfirmationState copyWith({
    PageState pageState,
    String account,
    String name,
    List<SendInfoLineItems> lineItems,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      account: account ?? this.account,
      name: name ?? this.name,
      lineItems: lineItems ?? this.lineItems,
    );
  }

  factory SendConfirmationState.initial() {
    return const SendConfirmationState(pageState: PageState.initial);
  }
}
