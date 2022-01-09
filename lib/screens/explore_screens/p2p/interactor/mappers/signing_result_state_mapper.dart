import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/p2p/interactor/viewmodels/p2p_bloc.dart';

class SigningResultStateMapper extends StateMapper {
  P2PState mapResultToState(P2PState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final scanQrCodeResult = result.asValue!.value as ScanQrCodeResultData;
      return currentState.copyWith(
        pageCommand: NavigateToRouteWithArguments(
          route: Routes.sendConfirmation,
          arguments: scanQrCodeResult.transaction,
        ),
      );
    }
  }
}
