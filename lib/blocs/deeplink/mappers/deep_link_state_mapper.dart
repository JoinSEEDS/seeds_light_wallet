import 'package:seeds/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/blocs/deeplink/model/invite_link_data.dart';
import 'package:seeds/blocs/deeplink/model/region_link_data.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/utils/result_extension.dart';
import 'package:seeds/utils/string_extension.dart';

// Example guardian Link: https://joinseeds.com/?placeholder&guardian=esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFdzSW8aAwPDg1W-E3cxMjJAABOUdoMJCPBcMvRdvD7S1NU_2MIsL8itJC_YvSTTODk50M0jOKPcKSjFMsXN0M0xxNDNvDC10tDHLNsvMbjA1Nk8qdAXaAoA
class DeepLinkStateMapper extends StateMapper {
  DeeplinkState mapResultToState(DeeplinkState currentState, DeepLinkData deepLinkData) {
    switch (deepLinkData.deepLinkPlaceHolder) {
      case DeepLinkPlaceHolder.guardian:
        final newPublicKey = deepLinkData.data['new_public_key'];
        final userAccount = deepLinkData.data['user_account'];
        return currentState.copyWith(
          showGuardianApproveOrDenyScreen: GuardianRecoveryRequestData(
            guardianAccount: userAccount,
            publicKey: newPublicKey,
          ),
        );
      case DeepLinkPlaceHolder.invite:
        if (settingsStorage.accountName.isNullOrEmpty) {
          // Handle invite link. Send user to memonic screen.
          return currentState.copyWith(inviteLinkData: InviteLinkData(deepLinkData.data['Mnemonic']));
        } else {
          //  If user is logged in, Ignore invite link
          return currentState;
        }
      case DeepLinkPlaceHolder.region:
        // Handle region link. Send user to region screen (join mode).
        return currentState.copyWith(regionLinkData: RegionLinkData(deepLinkData.data['region']));
      case DeepLinkPlaceHolder.invoice:
        final invite = deepLinkData.data['invoice'] as Result<dynamic>;
        if (invite.isValue) {
          return currentState.copyWith(signingRequest: invite.valueOrNull);
        } else {
          return currentState;
        }
      case DeepLinkPlaceHolder.unknown:
        // Don't know how to handle this link. Return current state
        return currentState;
    }
  }
}
