import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ClaimInviteCodeState extends Equatable {
  final PageState pageState;
  final String errorMessage;
  final String privateKey;
  final List<ProfileModel> accounts;

  const ClaimInviteCodeState({@required this.pageState, this.errorMessage, this.accounts, this.privateKey});

  @override
  List<Object> get props => [pageState];

  ClaimInviteCodeState copyWith({
    PageState pageState,
    String errorMessage,
    List<ProfileModel> accounts,
    String privateKey,
  }) {
    return ClaimInviteCodeState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      accounts: accounts ?? this.accounts,
      privateKey: privateKey ?? this.privateKey,
    );
  }

  factory ClaimInviteCodeState.initial() {
    return const ClaimInviteCodeState(
      pageState: PageState.initial,
      errorMessage: null,
      accounts: null,
      privateKey: null,
    );
  }
}
