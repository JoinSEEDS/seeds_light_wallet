import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/app/app.i18.dart';
import 'package:seeds/screens/app/interactor/viewmodels/app_bloc.dart';

class StopGuardianRecoveryStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure, pageCommand: ShowErrorMessage("Oops, something went wrong".i18n));
    } else {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: ShowMessage("Success, guardians recovery stopped".i18n));
    }
  }
}
