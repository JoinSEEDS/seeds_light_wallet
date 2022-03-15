import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'create_region_event_events.dart';

part 'create_region_event_state.dart';

class CreateRegionEventBloc extends Bloc<CreateRegionEventEvents, CreateRegionEventState> {
  CreateRegionEventBloc() : super(CreateRegionEventState.initial()) {
    on<ClearCreateRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }
}
