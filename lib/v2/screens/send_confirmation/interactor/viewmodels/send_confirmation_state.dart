import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_info_line_items.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final String account;
  final String name;
  final Map<String, dynamic> data;
  final List<SendInfoLineItems> lineItems;
  final String error;
  final ShowTransactionSuccess pageCommand;

  const SendConfirmationState({
    @required this.pageState,
    this.account,
    this.name,
    this.lineItems,
    this.data,
    this.error,
    this.pageCommand
  });

  @override
  List<Object> get props => [pageState];

  SendConfirmationState copyWith({
    PageState pageState,
    String account,
    String name,
    List<SendInfoLineItems> lineItems,
    Map<String, dynamic> data,
    String error,
    ShowTransactionSuccess pageCommand
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      account: account ?? this.account,
      name: name ?? this.name,
      lineItems: lineItems ?? this.lineItems,
      data: data ?? this.data,
      error: error ?? this.error,
      pageCommand: pageCommand ?? this.pageCommand
    );
  }

  factory SendConfirmationState.initial() {
    return const SendConfirmationState(pageState: PageState.initial);
  }
}
