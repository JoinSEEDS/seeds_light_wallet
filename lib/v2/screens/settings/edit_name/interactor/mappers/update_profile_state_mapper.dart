import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/settings/edit_name/viewmodels/edit_name_state.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';

class UpdateProfileStateMapper extends StateMapper {
  EditNameState mapResultToState(EditNameState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      final TransactionResponse res = result.asValue.value;
      return currentState.copyWith(pageState: PageState.success, name: res.data.nickname);
    }
  }
}
