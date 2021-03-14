import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/usecases/scanner_use_case.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/send_scanner_state.dart';

/// --- BLOC
class SendPageBloc extends Bloc<SendPageEvent, SendPageState> {
  SendPageBloc() : super(SendPageState.initial());

  @override
  Stream<SendPageState> mapEventToState(SendPageEvent event) async* {
    if (event is ShowError) {
      yield state.copyWith(pageState: PageState.failure);
    }
    if (event is ExecuteScanResult) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await ProcessScanResultUseCase().run(event.scanResult);

      if (result is ErrorResult) {
        yield state.copyWith(pageState: PageState.failure, error: result.error.toString());
      } else {
        yield state.copyWith(
          pageState: PageState.success,
          pageCommand: NavigateToCustomTransaction(result.asValue.value),
        );
      }
    }
  }
}
