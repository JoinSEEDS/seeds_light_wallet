import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/support/interactor/usecases/get_support_data_usecase.dart';
import 'package:seeds/screens/profile_screens/support/interactor/viewmodels/support_bloc.dart';

class SupportDataStateMapper extends StateMapper {
  SupportState mapResultToState(SupportState currentState, SupportDto results) {
    return currentState.copyWith(
        firebaseInstallationId: results.firebaseInstallationId,
        appName: results.appInfo.appName,
        version: results.appInfo.version,
        buildNumber: results.appInfo.buildNumber);
  }
}
