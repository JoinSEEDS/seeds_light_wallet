import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';

class GuardianStateMapper extends StateMapper {
  SecurityState mapResultToState(bool isGuardianActive, Iterable<GuardianModel> data, SecurityState currentState) {
    final myGuardians = data.where((element) => element.type == GuardianType.myGuardian);
    final alreadyGuardians = myGuardians.where((element) => element.status == GuardianStatus.alreadyGuardian);

    GuardiansStatus guardianState;

    if (alreadyGuardians.length < 3) {
      guardianState = GuardiansStatus.inactive;
    } else {
      if (isGuardianActive) {
        guardianState = GuardiansStatus.active;
      } else {
        guardianState = GuardiansStatus.readyToActivate;
      }
    }

    return currentState.copyWith(
      pageState: PageState.success,
      guardiansStatus: guardianState,
    );
  }
}
