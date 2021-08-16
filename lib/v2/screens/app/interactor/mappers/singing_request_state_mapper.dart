// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/v2/datasource/local/util/seeds_esr.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_state.dart';
import 'package:seeds/v2/i18n/app/app.i18.dart';

class SingingRequestStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Oops, something went wrong".i18n),
      );
    } else {
      final SeedsESR? request = result.asValue!.value;

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
