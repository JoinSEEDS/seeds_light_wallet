import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/utils/string_extension.dart';
import 'package:seeds/v2/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/v2/blocs/deeplink/model/invite_link_data.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';

// Example guardian Link: https://joinseeds.com/?placeholder&guardian=esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFdzSW8aAwPDg1W-E3cxMjJAABOUdoMJCPBcMvRdvD7S1NU_2MIsL8itJC_YvSTTODk50M0jOKPcKSjFMsXN0M0xxNDNvDC10tDHLNsvMbjA1Nk8qdAXaAoA
class DeepLinkStateMapper extends StateMapper {
  DeeplinkState mapResultToState(DeeplinkState currentState, Result result) {
    if (result.isError) {
      return currentState;
    } else {
      final deepLinkData = result.asValue!.value as DeepLinkData;

      switch (deepLinkData.deepLinkPlaceHolder) {
        case DeepLinkPlaceHolder.LINK_GUARDIANS:
          final newPublicKey = deepLinkData.data["new_public_key"];
          final userAccount = deepLinkData.data["user_account"];

          return currentState.copyWith(
            showGuardianApproveOrDenyScreen: GuardianRecoveryRequestData(
              guardianAccount: userAccount,
              publicKey: newPublicKey,
            ),
          );
        case DeepLinkPlaceHolder.LINK_INVITE:
          if (settingsStorage.accountName.isNullOrEmpty) {
            // handle invite link. Send user to memonic screen.
            final mnemonic = deepLinkData.data["Mnemonic"];
            return currentState.copyWith(inviteLinkData: InviteLinkData(mnemonic));
          } else {
            //  If user is logged in, Ignore invite link
            return currentState;
          }
        case DeepLinkPlaceHolder.LINK_UNKNOWN:
          // Don't know how to handle this link. Return current state
          return currentState;
      }
    }
  }

  DeeplinkState mapSigningRequestToState(DeeplinkState currentState, Result result) {
    if (result.isError) {
      return currentState;
    } else {
      final esr = result.asValue!.value as ScanQrCodeResultData;
      if (!settingsStorage.accountName.isNullOrEmpty) {
        // handle invite link. Send user to memonic screen.
        return currentState.copyWith(signingRequest: esr);
      } else {
        //  If user is not logged in, Ignore esr link
        return currentState;
      }
    }
  }
}
