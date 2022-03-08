import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_page_commands.dart';

part 'create_region_events.dart';

part 'create_region_state.dart';

class CreateRegionBloc extends Bloc<CreateRegionEvent, CreateRegionState> {
  CreateRegionBloc() : super(CreateRegionState.initial()) {
    on<OnNextTapped>(_onNextTapped);
    on<OnCreateRegionTapped>(_onCreateRegionTapped);
    on<OnBackPressed>(_onBackPressed);
    on<UploadImage>(_uploadImage);
    on<ClearCreateRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _uploadImage(UploadImage event, Emitter<CreateRegionState> emit) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 2000);
      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 50,
        );
        emit(state.copyWith(file: croppedFile, isUploadImageNextAvailable: true));
      }
    } catch (e) {
      emit(state.copyWith(pageCommand: ShowErrorMessage(e.toString())));
    }
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

  Future<void> _onCreateRegionTapped(OnCreateRegionTapped event, Emitter<CreateRegionState> emit) async {}

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
