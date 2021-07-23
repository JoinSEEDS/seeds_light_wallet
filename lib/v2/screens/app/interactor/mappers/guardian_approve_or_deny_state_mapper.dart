import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/get_initial_deep_link.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_state.dart';

// Example guardian Link: https://joinseeds.com/?placeholder&guardian=esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFdzSW8aAwPDg1W-E3cxMjJAABOUdoMJCPBcMvRdvD7S1NU_2MIsL8itJC_YvSTTODk50M0jOKPcKSjFMsXN0M0xxNDNvDC10tDHLNsvMbjA1Nk8qdAXaAoA
class GuardianApproveOrDenyStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState;
    } else {
      var deepLinkData = result.asValue!.value as DeepLinkData;

      switch (deepLinkData.deepLinkPlaceHolder) {
        case DeepLinkPlaceHolder.LINK_GUARDIANS:
          var newPublicKey = deepLinkData.data["new_public_key"];
          var userAccount = deepLinkData.data["user_account"];
          return currentState.copyWith(
              showGuardianApproveOrDenyScreen:
                  GuardianApproveOrDenyData(guardianAccount: userAccount, publicKey: newPublicKey));
        case DeepLinkPlaceHolder.LINK_INVITE:
          // TODO(gguij002): Handle invite links
          return currentState;
        case DeepLinkPlaceHolder.LINK_UNKNOWN:
          // Don't know how to handle this link. Return current state
          return currentState;
      }
    }
  }
}
