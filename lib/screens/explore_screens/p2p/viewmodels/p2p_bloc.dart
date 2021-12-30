import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:webview_flutter/platform_interface.dart';

part 'p2p_event.dart';
part 'p2p_state.dart';

class P2PBloc extends Bloc<P2PEvent, P2PState> {
  P2PBloc() : super(P2PState.initial()) {
    on<OnPageLoaded>((_, emit) => emit(state.copyWith(pageState: PageState.success)));
    on<OnMessageReceived>(_onMessageReceived);
  }

  Future<void> _onMessageReceived(OnMessageReceived event, Emitter<P2PState> emit) async {
    final esr = SeedsESR(uri: event.javascriptMessage.message);
    final result = await esr
        .resolve(account: settingsStorage.accountName)
        .then((value) => esr.processResolvedRequest())
        .catchError((_) {
      print(" processQrCode : Error processing QR code");
      return ErrorResult("Error processing QR code");
    });
    final scanQrCodeResult = result.asValue!.value as ScanQrCodeResultData;
    emit(state.copyWith(
        pageCommand:
            NavigateToRouteWithArguments(route: Routes.sendConfirmation, arguments: scanQrCodeResult.transaction)));
  }
}
