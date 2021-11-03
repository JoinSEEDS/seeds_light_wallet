import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_scanner/interactor/usecases/scanner_use_case.dart';
import 'package:seeds/screens/transfer/send/send_scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/screens/transfer/send/send_scanner/interactor/viewmodels/send_scanner_state.dart';

/// --- BLOC
class SendPageBloc extends Bloc<SendPageEvent, SendPageState> {
  SendPageBloc() : super(SendPageState.initial());

  @override
  Stream<SendPageState> mapEventToState(SendPageEvent event) async* {
    if (event is ExecuteScanResult) {
      // If we are loading, dont handle any upcoming commands
      if (state.pageState != PageState.loading) {
        yield state.copyWith(pageState: PageState.loading);

        final Result result = await ProcessScanResultUseCase().run(event.scanResult);

        if (result is ErrorResult) {
          yield state.copyWith(pageState: PageState.failure, errorMessage: result.error.toString());
        } else {
          final value = result.asValue!.value as ScanQrCodeResultData;

          final args = SendConfirmationArguments(
            transaction: value.transaction,
          );

          yield state.copyWith(
            pageState: PageState.success,
            pageCommand: NavigateToRouteWithArguments(route: Routes.sendConfirmation, arguments: args),
          );
        }
      }
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
