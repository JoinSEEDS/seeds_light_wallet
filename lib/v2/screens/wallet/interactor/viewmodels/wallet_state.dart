import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class WalletState extends Equatable {
  final PageState pageState;
  final String availableSeeds;
  final String errorMessage;

  WalletState({
    @required this.pageState,
    this.availableSeeds,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
    pageState,
    availableSeeds,
    errorMessage,
  ];

  WalletState copyWith({
    PageState pageState,
    ProfileModel profile,
    String errorMessage,
  }) {
    return WalletState(
      pageState: pageState ?? this.pageState,
      availableSeeds: profile ?? this.availableSeeds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory WalletState.initial() {
    return WalletState(
      pageState: PageState.initial,
      availableSeeds: null,
      errorMessage: null,
    );
  }
}
