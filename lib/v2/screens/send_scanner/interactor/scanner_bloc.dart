import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/scanner_state.dart';

/// --- BLOC
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerState.initial());

  @override
  Stream<ScannerState> mapEventToState(ScannerEvent event) async* {
    if (event is ShowError) {
      yield state.copyWith(pageState: PageState.failure);
    }
  }
}
