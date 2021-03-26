import 'package:bloc/bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/edit_profile_pic_bottom_sheet/interactor/viewmodels/bloc.dart';

/// --- BLOC
class PickImageBloc extends Bloc<PickImageEvent, PickImageState> {
  PickImageBloc() : super(PickImageState.initial());

  @override
  Stream<PickImageState> mapEventToState(PickImageEvent event) async* {
    if (event is GetImage) {
      try {
        var image = await ImagePicker().getImage(source: event.source, imageQuality: 50);
        if (image != null) {
          var croppedFile = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          );
          yield state.copyWith(file: croppedFile);
        }
      } catch (e) {
        yield state.copyWith(errorMessage: e);
      }
    }
  }
}
