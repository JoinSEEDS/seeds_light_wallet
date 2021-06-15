import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/v2/screens/transfer/send/send_scanner/interactor/usecases/scanner_use_case.dart';
import 'package:seeds/v2/screens/transfer/send/send_scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/transfer/send/send_scanner/interactor/viewmodels/send_scanner_state.dart';

/// --- BLOC
class SendPageBloc extends Bloc<SendPageEvent, SendPageState> {
  SendPageBloc() : super(SendPageState.initial());

  @override
  Stream<SendPageState> mapEventToState(SendPageEvent event) async* {
    if (event is ExecuteScanResult) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await ProcessScanResultUseCase().run(event.scanResult);

      if (result is ErrorResult) {
        yield state.copyWith(pageState: PageState.failure, error: result.error.toString());
      } else {
        var value = result.asValue!.value as ScanQrCodeResultData;

        var args = SendConfirmationArguments(
          account: value.accountName,
          name: value.name,
          data: value.data,
        );

        yield state.copyWith(
          pageState: PageState.success,
          pageCommand: NavigateToRouteWithArguments(route: Routes.sendConfirmationScreen, arguments: args),
        );
      }
    }
  }
}
