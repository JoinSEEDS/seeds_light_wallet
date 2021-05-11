import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/edit_name/interactor/viewmodels/edit_name_state.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_state.dart';

class InitGuardiansStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Initializing Guardians");
    } else {
      // TODO(gguij002): show success toast
      return currentState.copyWith(pageState: PageState.success);
    }
  }
}
