import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';

part 'edit_region_events.dart';

part 'edit_region_state.dart';

class EditRegionBloc extends Bloc<EditRegionEvent, EditRegionState> {
  EditRegionBloc(RegionModel region) : super(EditRegionState.initial(region)) {
    on<OnRegionDescriptionChange>(_onOnRegionDescriptionChange);
    on<OnEditRegionSaveChangesTapped>(_onEditRegionSaveChangesTapped);
    on<ClearEditRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onOnRegionDescriptionChange(OnRegionDescriptionChange event, Emitter<EditRegionState> emit) {
    if (event.regionDescription.isEmpty) {
      emit(state.copyWith(newRegionDescription: event.regionDescription));
    } else {
      emit(
        state.copyWith(newRegionDescription: event.regionDescription),
      );
    }
  }

  Future<void> _onEditRegionSaveChangesTapped(
      OnEditRegionSaveChangesTapped event, Emitter<EditRegionState> emit) async {}
}
