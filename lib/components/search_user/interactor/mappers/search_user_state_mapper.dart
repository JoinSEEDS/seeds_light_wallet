import 'package:seeds/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class SearchUserStateMapper extends StateMapper {
  SearchUserState mapResultToState(SearchUserState currentState, Result result, List<String>? noShowUsers) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Searching for User');
    } else {
      final List<MemberModel> users = result.asValue?.value as List<MemberModel>;
      if (noShowUsers != null) {
        for (final noShowUser in noShowUsers) {
          users.removeWhere((element) => element.account == noShowUser);
        }
      }
      return currentState.copyWith(pageState: PageState.success, users: users);
    }
  }
}
