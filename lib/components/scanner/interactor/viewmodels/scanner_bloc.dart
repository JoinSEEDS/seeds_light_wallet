import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerState.initial()) {
    on<ShowLoading>((_, emit) => emit(state.copyWith(scanStatus: ScanStatus.processing)));
    on<Scan>((_, emit) => emit(state.copyWith(scanStatus: ScanStatus.scan)));
  }
}
