import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image_event.dart';

part 'pick_image_state.dart';

class PickImageBloc extends Bloc<PickImageEvent, PickImageState> {
  PickImageBloc() : super(PickImageState.initial()) {
    on<GetImage>(_getImage);
  }

  Future<void> _getImage(GetImage event, Emitter<PickImageState> emit) async {
    try {
      final image = await ImagePicker().pickImage(source: event.source, imageQuality: 50, maxWidth: 2000);
      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 50,
        );
        emit(state.copyWith(file: File(croppedFile!.path)));
      }
    } catch (e) {
      // TODO(raul): Use a snackbar to show generic error here, https://github.com/JoinSEEDS/seeds_light_wallet/pull/614
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
