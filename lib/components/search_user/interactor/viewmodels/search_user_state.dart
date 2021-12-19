part of 'search_user_bloc.dart';

class SearchUserState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<MemberModel> users;
  final bool showClearIcon;
  final List<String>? noShowUsers;
  final UserCitizenshipStatus? showOnlyCitizenshipStatus;

  const SearchUserState({
    required this.pageState,
    this.errorMessage,
    required this.users,
    required this.showClearIcon,
    this.noShowUsers,
    this.showOnlyCitizenshipStatus,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        users,
        showClearIcon,
        noShowUsers,
        showOnlyCitizenshipStatus,
      ];

  SearchUserState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<MemberModel>? users,
    bool? showClearIcon,
    List<String>? noShowUsers,
    UserCitizenshipStatus? showOnlyCitizenshipStatus,
  }) {
    return SearchUserState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      users: users ?? this.users,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      showOnlyCitizenshipStatus: showOnlyCitizenshipStatus ?? this.showOnlyCitizenshipStatus,
    );
  }

  factory SearchUserState.initial(List<String>? noShowUsers, UserCitizenshipStatus? filterByCitizenshipStatus) {
    return SearchUserState(
      pageState: PageState.initial,
      users: [],
      showClearIcon: false,
      noShowUsers: noShowUsers,
      showOnlyCitizenshipStatus: filterByCitizenshipStatus,
    );
  }
}
