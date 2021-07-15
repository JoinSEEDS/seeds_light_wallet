import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SearchUserState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<MemberModel> users;
  final IconData searchBarIcon;
  final List<String>? noShowUsers;

  const SearchUserState({
    required this.pageState,
    this.errorMessage,
    required this.users,
    required this.searchBarIcon,
    this.noShowUsers,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        users,
        searchBarIcon,
        noShowUsers,
      ];

  SearchUserState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<MemberModel>? users,
    IconData? searchBarIcon,
    List<String>? noShowUsers,
  }) {
    return SearchUserState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      users: users ?? this.users,
      searchBarIcon: searchBarIcon ?? this.searchBarIcon,
      noShowUsers: noShowUsers ?? this.noShowUsers,
    );
  }

  factory SearchUserState.initial(List<String>? noShowUsers) {
    return SearchUserState(
      pageState: PageState.initial,
      users: [],
      searchBarIcon: Icons.search,
      noShowUsers: noShowUsers,
    );
  }
}
