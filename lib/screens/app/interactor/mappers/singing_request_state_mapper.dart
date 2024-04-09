import 'package:seeds/datasource/local/util/seeds_esr.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/app/app.i18.dart';
import 'package:seeds/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:seeds/screens/app/interactor/viewmodels/app_page_commands.dart';

class SingingRequestStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Oops, something went wrong".i18n),
      );
    } else {
      final SeedsESR? request = result.asValue!.value as SeedsESR?;

      if (request != null) {
        return currentState.copyWith(
            pageCommand: ProcessSigningRequest(request.actions.first),
            showGuardianApproveOrDenyScreen: currentState.showGuardianApproveOrDenyScreen);
      } else {
        // No initial uri
        return currentState;
      }
    }
  }
}
