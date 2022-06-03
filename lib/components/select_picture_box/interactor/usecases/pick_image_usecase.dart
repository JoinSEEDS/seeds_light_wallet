import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class PickImageUseCase extends NoInputUseCase<File> {
  @override
  Future<Result<File>> run() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 2000);
      if (image != null) {
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path, aspectRatioPresets: [CropAspectRatioPreset.ratio5x3], compressQuality: 50);

        if (croppedFile != null) {
          return Result.value(File(croppedFile.path));
        }
        return Result.error("Error on croppedFile");
      }
    } catch (e) {
      print(e.toString());
      return Result.error(e);
    }
    return Result.error("Error Loading Image");
  }
}
