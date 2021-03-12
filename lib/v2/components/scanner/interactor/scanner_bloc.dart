import 'package:bloc/bloc.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_state.dart';

/// --- BLOC
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerState.initial());

  @override
  Stream<ScannerState> mapEventToState(ScannerEvent event) async* {
    if (event is ShowError) {
      yield state.copyWith(pageState: PageState.error);
    } else if (event is ShowLoading) {
      yield state.copyWith(pageState: PageState.processing);
    } else if (event is Scan) {
      yield state.copyWith(pageState: PageState.scan);
    }
  }
}
