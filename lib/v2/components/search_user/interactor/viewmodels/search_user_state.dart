import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SearchUserState extends Equatable {
  final PageState pageState;
  final String? error;
  final List<MemberModel> users;
  final IconData searchBarIcon;

  const SearchUserState({required this.pageState, this.error, required this.users, required this.searchBarIcon});

  @override
  List<Object?> get props => [pageState, error, users, searchBarIcon];

  SearchUserState copyWith({PageState? pageState, String? error, List<MemberModel>? users, IconData? searchBarIcon}) {
    return SearchUserState(
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
      users: users ?? this.users,
      searchBarIcon: searchBarIcon ?? this.searchBarIcon,
    );
  }

  factory SearchUserState.initial() {
    return const SearchUserState(pageState: PageState.initial, users: [], searchBarIcon: Icons.search);
  }
}
