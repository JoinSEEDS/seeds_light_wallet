import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/select_picture_box/interactor/usecases/pick_image_usecase.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/firebase/regions/create_region_use_case.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_region_by_id_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_image_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/components/authentication_status.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/create_region_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/generate_region_id_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/pick_image_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/region_id_availability_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/save_image_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/mappers/validate_region_Id.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_page_commands.dart';

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
    on<OnRegionIdChange>(_onRegionIdChange, transformer: _transformEvents);
    on<OnPickImage>(_onPickImage);
    on<OnPickImageNextTapped>(_onPickImageNextTapped);
    on<OnConfirmCreateRegionTapped>(_onConfirmCreateRegionTapped);
    on<OnPublishRegionTapped>(_onPublishRegionTapped);
    on<ClearCreateRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  /// Debounce to avoid making search network calls each time the user types (RegionId chain validation)
  /// switchMap: To remove the previous event. Every time a new Stream is created, the previous Stream is discarded.
  Stream<OnRegionIdChange> _transformEvents(
      Stream<OnRegionIdChange> events, Stream<OnRegionIdChange> Function(OnRegionIdChange) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  void _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<CreateRegionState> emit) {
    emit(state.copyWith(currentPlace: event.place));
  }

  void _onRegionNameChange(OnRegionNameChange event, Emitter<CreateRegionState> emit) {
    emit(state.copyWith(regionName: event.regionName));
  }

  void _onRegionNameNextTapped(OnRegionNameNextTapped event, Emitter<CreateRegionState> emit) {
    if (state.regionId.isEmpty) {
      emit(GenerateRegionIdStateMapper().mapResultToState(state));
    } else {
      emit(state.copyWith(createRegionsScreens: CreateRegionScreen.regionId));
    }
  }

  void _onOnRegionDescriptionChange(OnRegionDescriptionChange event, Emitter<CreateRegionState> emit) {
    emit(state.copyWith(regionDescription: event.regionDescription));
  }

  Future<void> _onRegionIdChange(OnRegionIdChange event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(regionIdValidationStatus: RegionIdStatusIcon.loading));
    final String? error = ValidateRegionIdMapper().hasError(event.regionId);
    if (error != null) {
      emit(state.copyWith(
        regionId: event.regionId,
        regionIdValidationStatus: RegionIdStatusIcon.invalid,
        regionIdErrorMessage: error,
      ));
    } else {
      final Result<RegionModel?> result = await GetRegionByIdUseCase().run("${event.regionId}$regionIdSuffix");
      emit(RegionIdAvailabilityStateMapper().mapResultToState(state, result));
    }
  }

  Future<void> _onPickImage(OnPickImage event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(pictureBoxState: PictureBoxState.loading));
    final result = await PickImageUseCase().run();
    emit(PickImageStateMapper().mapResultToState(state, result));
  }

  Future<void> _onPickImageNextTapped(OnPickImageNextTapped event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(isNextButtonLoading: true));
    if (state.createImageUrl) {
      final Result<String> urlResult = await SaveImageUseCase()
          .run(SaveImageUseCaseInput(file: state.file!, pathPrefix: PathPrefix.regionImage, creatorId: state.regionId));
      emit(SaveImageStateMapper().mapResultToState(state, urlResult));
    } else {
      emit(state.copyWith(createRegionsScreens: CreateRegionScreen.reviewRegion, isNextButtonLoading: false));
    }
  }

  Future<void> _onConfirmCreateRegionTapped(OnConfirmCreateRegionTapped event, Emitter<CreateRegionState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    final Result<TransactionResponse> result = await CreateRegionUseCase().run(CreateRegionUseCase.input(
        regionAccount: "${state.regionId}$regionIdSuffix",
        title: state.regionName,
        description: state.regionDescription,
        latitude: state.currentPlace!.lat,
        longitude: state.currentPlace!.lng,
        regionAddress: state.currentPlace!.placeText,
        imageUrl: state.imageUrl!));
    emit(CreateRegionStateMapper().mapResultToState(state, result));
  }

  void _onPublishRegionTapped(OnPublishRegionTapped event, Emitter<CreateRegionState> emit) {
    emit(state.copyWith(pageCommand: ShowCreateRegionConfirmation()));
  }

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
