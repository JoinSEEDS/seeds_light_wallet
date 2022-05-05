import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/select_picture_box/interactor/usecases/pick_image_usecase.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/mappers/edit_region_description_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/mappers/pick_region_image_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/usecases/edit_region_description_use_case.dart';

part 'edit_region_events.dart';

part 'edit_region_state.dart';

class EditRegionBloc extends Bloc<EditRegionEvent, EditRegionState> {
  EditRegionBloc(RegionModel region) : super(EditRegionState.initial(region)) {
    on<OnPickImage>(_onPickImage);
    on<OnRegionDescriptionChange>(_onOnRegionDescriptionChange);
    on<OnEditRegionSaveChangesTapped>(_onEditRegionSaveChangesTapped);
    on<ClearEditRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onPickImage(OnPickImage event, Emitter<EditRegionState> emit) async {
    emit(state.copyWith(pictureBoxState: PictureBoxState.loading));
    final result = await PickImageUseCase().run();
    emit(PickRegionImageStateMapper().mapResultToState(state, result));
  }

  void _onOnRegionDescriptionChange(OnRegionDescriptionChange event, Emitter<EditRegionState> emit) {
    emit(state.copyWith(newRegionDescription: event.regionDescription));
  }

  Future<void> _onEditRegionSaveChangesTapped(
      OnEditRegionSaveChangesTapped event, Emitter<EditRegionState> emit) async {
    emit(state.copyWith(isSaveChangesButtonLoading: true));

    final Result<TransactionResponse> result =
        await EditRegionDescriptionUseCase().run(EditRegionDescriptionUseCase.input(
      regionAccount: state.region.id,
      title: state.region.title,
      description: state.newRegionDescription,
      latitude: state.region.latitude,
      longitude: state.region.longitude,
    ));
    emit(EditRegionDescriptionStateMapper().mapResultToState(state, result));
  }
}
