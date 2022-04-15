import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_region_events.dart';

part 'edit_region_state.dart';

class EditRegionBloc extends Bloc<EditRegionEvent, EditRegionState> {
  EditRegionBloc() : super(EditRegionState.initial()) {
    on<OnRegionDescriptionChange>(_onOnRegionDescriptionChange);
    on<OnEditRegionSaveChangesTapped>(_onEditRegionSaveChangesTapped);
    on<ClearEditRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onOnRegionDescriptionChange(OnRegionDescriptionChange event, Emitter<EditRegionState> emit) {
    if (event.regionDescription.isEmpty) {
      emit(state.copyWith(regionDescription: event.regionDescription));
    } else {
      emit(
        state.copyWith(regionDescription: event.regionDescription),
      );
    }
  }

  Future<void> _onEditRegionSaveChangesTapped(
      OnEditRegionSaveChangesTapped event, Emitter<EditRegionState> emit) async {}
}
