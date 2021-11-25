import 'package:seeds/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class SearchUserStateMapper extends StateMapper {
  SearchUserState mapResultToState({
    required SearchUserState currentState,
    required Result<List<MemberModel>> seedsMembersResult,
    required Result<List<MemberModel>> telosResult,
    required Result<List<MemberModel>> fullNameResult,
    List<String>? noShowUsers,
  }) {
    if (seedsMembersResult.isError && telosResult.isError && fullNameResult.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Searching for User');
    } else {
      final List<MemberModel> seedsUsers = seedsMembersResult.asValue?.value ?? [];
      final List<MemberModel> telosUsers = telosResult.asValue?.value ?? [];
      final List<MemberModel> fullNameUsers = fullNameResult.asValue?.value ?? [];

      final existingSet = <String>{};
      final noShowSet = Set.from(noShowUsers ?? []);

      /// This is the order in which the list will display
      /// - first account name matches
      /// - second full name matches
      /// - third Telos account name matches
      final users = seedsUsers + fullNameUsers + telosUsers;

      final uniqueUsers = <MemberModel>[];

      for (final member in users) {
        if (!(existingSet.contains(member.account) || noShowSet.contains(member.account))) {
          uniqueUsers.add(member);
          existingSet.add(member.account);
        }
      }

      if (currentState.showOnlyCitizenshipStatus != null) {
        uniqueUsers.removeWhere((element) => element.citizenshipStatus != currentState.showOnlyCitizenshipStatus);
      }

      return currentState.copyWith(pageState: PageState.success, users: uniqueUsers);
    }
  }
}
