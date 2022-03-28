import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/select_picture_box/interactor/usecases/pick_image_usecase.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/choose_region_id/components/authentication_status.dart';
import 'package:seeds/screens/create_region_screens/interactor/mappers/generate_region_id_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/mappers/pick_image_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/mappers/validate_region_id_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/usecases/validate_region_id_usecase.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_page_commands.dart';

part 'create_region_events.dart';

part 'create_region_state.dart';

class CreateRegionBloc extends Bloc<CreateRegionEvent, CreateRegionState> {
  CreateRegionBloc() : super(CreateRegionState.initial()) {
    on<OnNextTapped>(_onNextTapped);
    on<OnBackPressed>(_onBackPressed);
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<OnRegionNameChange>(_onRegionNameChange);
    on<OnRegionNameNextTapped>(_onRegionNameNextTapped);
    on<OnRegionDescriptionChange>(_onOnRegionDescriptionChange);
    on<OnRegionIdChange>(_onRegionIdChange);
    on<OnPickImage>(_onPickImage);
    on<OnPickImageNextTapped>(_onPickImageNextTapped);
    on<OnCreateRegionTapped>(_onCreateRegionTapped);
    on<ClearCreateRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<CreateRegionState> emit) {
    emit(state.copyWith(currentPlace: event.place));
  }

  void _onRegionNameChange(OnRegionNameChange event, Emitter<CreateRegionState> emit) {
    if (event.regionName.isEmpty) {
      emit(state.copyWith(regionName: event.regionName, isRegionNameNextButtonEnable: false));
    } else {
      emit(
        state.copyWith(regionName: event.regionName, isRegionNameNextButtonEnable: true),
      );
    }
  }

  void _onRegionNameNextTapped(OnRegionNameNextTapped event, Emitter<CreateRegionState> emit) {
    if (state.regionId.isEmpty) {
      emit(GenerateRegionIdStateMapper().mapResultToState(state));
    } else {
      emit(state.copyWith(createRegionsScreens: CreateRegionScreen.regionId));
    }
  }

  void _onOnRegionDescriptionChange(OnRegionDescriptionChange event, Emitter<CreateRegionState> emit) {
    if (event.regionDescription.isEmpty) {
      emit(state.copyWith(regionDescription: event.regionDescription, isRegionDescriptionNextButtonEnable: false));
    } else {
      emit(
        state.copyWith(regionDescription: event.regionDescription, isRegionDescriptionNextButtonEnable: true),
      );
    }
  }

  Future<void> _onRegionIdChange(OnRegionIdChange event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(regionIdAuthenticationState: RegionIdStatusIcon.loading));
    if (event.regionId.isEmpty) {
      emit(state.copyWith(
          regionId: event.regionId,
          regionIdAuthenticationState: RegionIdStatusIcon.invalid,
          regionIdErrorMessage: "Region Id cannot be empty"));
    } else {
      final Result<RegionModel?> result = await ValidateRegionIdUseCase().run(event.regionId);
      emit(ValidateRegionIdStateMapper().mapResultToState(state, result));
      emit(state.copyWith(regionId: event.regionId));
    }
  }

  Future<void> _onPickImage(OnPickImage event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(pictureBoxState: PictureBoxState.loading, imageUrl: state.imageUrl));
    final result = await PickImageUseCase().run();
    emit(PickImageStateMapper().mapResultToState(state, result));
  }

  Future<void> _onPickImageNextTapped(OnPickImageNextTapped event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(imageUrl: state.imageUrl));

    // TODO(gguij004): need to wait for region ID screen to be completed before using this usecases.
    // if (state.imageUrl == null) {
    //   final Result<String> urlResult = await SaveImageUseCase()
    //       .run(SaveImageUseCaseInput(file: state.file!, pathPrefix: PathPrefix.regionImage, creatorId: "TODO"));
    //   emit(SaveImageStateMapper().mapResultToState(state, urlResult));
    // }

    emit(state.copyWith(
        pageState: PageState.success, createRegionsScreens: CreateRegionScreen.reviewRegion, imageUrl: state.imageUrl));
  }

  Future<void> _onCreateRegionTapped(OnCreateRegionTapped event, Emitter<CreateRegionState> emit) async {}

  void _onNextTapped(OnNextTapped event, Emitter<CreateRegionState> emit) {
    switch (state.createRegionsScreens) {
      case CreateRegionScreen.selectRegion:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.displayName));
        break;
      case CreateRegionScreen.displayName:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.regionId));
        break;
      case CreateRegionScreen.regionId:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.addDescription));
        break;
      case CreateRegionScreen.addDescription:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.selectBackgroundImage));
        break;
      case CreateRegionScreen.selectBackgroundImage:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.reviewRegion));
        break;
      case CreateRegionScreen.reviewRegion:
        break;
    }
  }

  void _onBackPressed(OnBackPressed event, Emitter<CreateRegionState> emit) {
    switch (state.createRegionsScreens) {
      case CreateRegionScreen.selectRegion:
        emit(state.copyWith(pageCommand: ReturnToJoinRegion()));
        break;
      case CreateRegionScreen.displayName:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.selectRegion));
        break;
      case CreateRegionScreen.regionId:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.displayName));
        break;
      case CreateRegionScreen.addDescription:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.regionId));
        break;
      case CreateRegionScreen.selectBackgroundImage:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.addDescription));
        break;
      case CreateRegionScreen.reviewRegion:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreen.selectBackgroundImage));
        break;
    }
  }
}
