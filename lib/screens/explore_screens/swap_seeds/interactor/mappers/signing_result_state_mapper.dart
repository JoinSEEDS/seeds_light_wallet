import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/swap_seeds/interactor/viewmodels/swap_seeds_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

class SigningResultStateMapper extends StateMapper {
  SwapSeedsState mapResultToState(SwapSeedsState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final scanQrCodeResult = result.asValue!.value as ScanQrCodeResultData;
      return currentState.copyWith(
        pageCommand: NavigateToSendConfirmation(
          SendConfirmationArguments.from(scanQrCodeResult),
        ),
      );
    }
  }
}
