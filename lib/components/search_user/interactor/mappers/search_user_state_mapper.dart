import 'package:seeds/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class SearchUserStateMapper extends StateMapper {
  SearchUserState mapResultToState(
      SearchUserState currentState, Result seedsMembersResult, Result telosResult, List<String>? noShowUsers) {
    if (seedsMembersResult.isError && telosResult.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Searching for User');
    } else {
      List<MemberModel> seedsUsers = [];
      List<MemberModel> telosUsers = [];

      if (seedsMembersResult.isValue) {
        seedsUsers = seedsMembersResult.asValue?.value as List<MemberModel>;
        if (noShowUsers != null) {
          for (final noShowUser in noShowUsers) {
            seedsUsers.removeWhere((element) => element.account == noShowUser);
          }
        }
      }

      if (telosResult.isValue) {
        final seedsSet = Set.from(seedsUsers.map((e) => e.account));
        telosUsers = telosResult.asValue?.value as List<MemberModel>;
        telosUsers.removeWhere((element) => seedsSet.contains(element.account));
      }

      final users = seedsUsers + telosUsers;

      return currentState.copyWith(pageState: PageState.success, users: users);
    }
  }
}
