import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

part 'edit_region_event_events.dart';

part 'edit_region_event_state.dart';

class EditRegionEventBloc extends Bloc<EditRegionEventEvents, EditRegionEventState> {
  EditRegionEventBloc(RegionEventModel event) : super(EditRegionEventState.initial(event)) {
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<ClearEditRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<EditRegionEventState> emit) {
    emit(state.copyWith(newPlace: event.place));
  }
}
