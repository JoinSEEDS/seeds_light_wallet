import 'package:seeds/v2/utils/string_extension.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';

class EosioSigningRequestStateMapper extends StateMapper {
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
