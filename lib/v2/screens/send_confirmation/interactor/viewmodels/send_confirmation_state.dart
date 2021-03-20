import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final String account;
  final String name;
  final Map<String, dynamic> data;

  const SendConfirmationState({
    @required this.pageState,
    this.account,
    this.name,
    this.data,
  });

  @override
  List<Object> get props => [pageState];

  SendConfirmationState copyWith({
    PageState pageState,
    String account,
    String name,
    Map<String, dynamic> data,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      account: account ?? this.account,
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }

  factory SendConfirmationState.initial() {
    return const SendConfirmationState(pageState: PageState.initial);
  }
}
