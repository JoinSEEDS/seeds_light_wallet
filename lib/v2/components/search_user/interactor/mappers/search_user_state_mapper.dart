import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';

class SearchUserStateMapper extends StateMapper {
  SearchUserState mapResultToState(SearchUserState currentState, Result result, List<String>? noShowUsers) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Searching for User');
    } else {
      List<MemberModel> users = result.asValue?.value as List<MemberModel>;
      noShowUsers?.forEach((noShowUser) {
        users.removeWhere((element) => element.account == noShowUser);
      });
      return currentState.copyWith(pageState: PageState.success, users: users, errorMessage: null);
    }
  }
}
