import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/scanner/interactor/mappers/scanner_state_mapper.dart';
import 'package:seeds/v2/screens/scanner/interactor/usecases/scanner_use_case.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_state.dart';


/// --- BLOC
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerState.initial());

  @override
  Stream<ScannerState> mapEventToState(ScannerEvent event) async* {
    if (event is TodoNetworkCall) {
      yield state.copyWith(pageState: PageState.loading);

      var results = await TodoScannerUseCase().run(event.todoParamName);

      yield ScannerStateMapper().mapResultToState(state, results);
    }
  }
}
