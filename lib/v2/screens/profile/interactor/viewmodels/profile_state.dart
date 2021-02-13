import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ProfileState extends Equatable {
  final PageState pageState;
  final ProfileModel profile;
  final String errorMessage;

  ProfileState({
    @required this.pageState,
    this.profile,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        profile,
        errorMessage,
      ];

  ProfileState copyWith({
    PageState pageState,
    ProfileModel profile,
    String errorMessage,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() {
    return ProfileState(
      pageState: PageState.initial,
      profile: null,
      errorMessage: null,
    );
  }
}
