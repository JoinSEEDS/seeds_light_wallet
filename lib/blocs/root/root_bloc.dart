import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  late StreamSubscription _snackSubscription;

  RootBloc() : super(RootState.initial()) {
    _snackSubscription = eventBus.on<ShowSnackBar>().listen((event) async => add(OnRootBusEventRecived(event)));
    on<OnRootBusEventRecived>((event, emit) => emit(state.copyWith(busEvent: event.busEvent)));
    on<ClearRootBusEvent>((event, emit) => emit(state.copyWith()));
  }

  @override
  Future<void> close() async {
    await _snackSubscription.cancel();
    return super.close();
  }
}
