import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;
  final String errorMessage;
  final List<ProfileModel> accounts;

  const ImportKeyState({@required this.pageState, this.errorMessage, this.accounts});

  @override
  List<Object> get props => [pageState];

  ImportKeyState copyWith({
    PageState pageState,
    String errorMessage,
    List<ProfileModel> accounts,
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      accounts: accounts ?? this.accounts,
    );
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      pageState: PageState.initial,
      errorMessage: null,
      accounts: null,
    );
  }
}
