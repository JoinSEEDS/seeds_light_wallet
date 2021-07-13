import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_state.dart';

class NoShowGuardiansMapper extends StateMapper {
  SelectGuardiansState mapResultToState(SelectGuardiansState currentState, List<String> results) {
    return currentState.copyWith(pageState: PageState.failure,);


  }
}
