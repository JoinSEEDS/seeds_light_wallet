import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/security_state.dart';
import 'package:flutter/cupertino.dart';

class GuardianStateMapper extends StateMapper {
  SecurityState mapResultToState(bool isGuardianActive, Iterable<GuardianModel> data, SecurityState currentState) {
    var myGuardians = data.where((element) => element.type == GuardianType.myGuardian);
    var alreadyGuardians = myGuardians.where((element) => element.status == GuardianStatus.alreadyGuardian);

    Widget guardianStateText;

    if (alreadyGuardians.length < 3) {
      guardianStateText = const Text(
        "Inactive",
        style: TextStyle(color: AppColors.red),
      );
    } else {
      if (isGuardianActive) {
        guardianStateText = const Text("Active",
            style: TextStyle(
              color: AppColors.green1,
            ));
      } else {
        guardianStateText = const Text(
          "Ready To Activate",
          style: TextStyle(color: AppColors.orange),
        );
      }
    }

    return currentState.copyWith(
      pageState: PageState.success,
      guardianStatusText: guardianStateText,
    );
  }
}
