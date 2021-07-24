import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_state.dart';

// Example guardian Link: https://joinseeds.com/?placeholder&guardian=esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFdzSW8aAwPDg1W-E3cxMjJAABOUdoMJwICpq3-waWSJq3d-UUhhaFlEuVdFUblpaLBFuKGFaVS6b1mhb6hXeliEZWCKT3p5nkuoX5h5SRbQFAA
// Example invite link: https://joinseeds.com/?placeholder&inviteMnemonic=someword-someotherword-etc-etc-andonelastword

class GuardianApproveOrDenyStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Uri newLink) {
    var splitUri = newLink.query.split('=');
    var placeHolder = splitUri[0];

    if (placeHolder.contains("guardian")) {
      return currentState.copyWith(showGuardianApproveOrDenyScreen: true);
    } else if (newLink.queryParameters["inviteMnemonic"] != null) {
      return currentState.copyWith(pageCommand: ProcessInviteLink(newLink.queryParameters["inviteMnemonic"]!));
    } else {
      // Don't know how to handle this link. Return current state
      return currentState;
    }
  }
}
