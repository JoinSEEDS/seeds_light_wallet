import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';

class SearchUserState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<MemberModel> users;
  final IconData searchBarIcon;
  final List<String>? noShowUsers;
  final UserCitizenshipStatus? showOnlyCitizenshipStatus;

  const SearchUserState({
    required this.pageState,
    this.errorMessage,
    required this.users,
    required this.searchBarIcon,
    this.noShowUsers,
    this.showOnlyCitizenshipStatus,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        users,
        searchBarIcon,
        noShowUsers,
        showOnlyCitizenshipStatus,
      ];

  SearchUserState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<MemberModel>? users,
    IconData? searchBarIcon,
    List<String>? noShowUsers,
    UserCitizenshipStatus? showOnlyCitizenshipStatus,
  }) {
    return SearchUserState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      users: users ?? this.users,
      searchBarIcon: searchBarIcon ?? this.searchBarIcon,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      showOnlyCitizenshipStatus: showOnlyCitizenshipStatus ?? this.showOnlyCitizenshipStatus,
    );
  }

  factory SearchUserState.initial(List<String>? noShowUsers, UserCitizenshipStatus? filterByCitizenshipStatus) {
    return SearchUserState(
      pageState: PageState.initial,
      users: [],
      searchBarIcon: Icons.search,
      noShowUsers: noShowUsers,
      showOnlyCitizenshipStatus: filterByCitizenshipStatus,
    );
  }
}
