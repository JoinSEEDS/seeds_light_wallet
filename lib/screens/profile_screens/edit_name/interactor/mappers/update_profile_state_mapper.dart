import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/edit_name_bloc.dart';

class UpdateProfileStateMapper extends StateMapper {
  EditNameState mapResultToState(EditNameState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final TransactionResponse res = result.asValue!.value;
      return currentState.copyWith(pageState: PageState.success, name: res.data!.nickname);
    }
  }
}
