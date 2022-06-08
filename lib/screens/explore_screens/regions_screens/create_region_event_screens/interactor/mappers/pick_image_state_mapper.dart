import 'dart:io';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class PickImageStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, Result<File?> result) {
    if (result.isError) {
      return currentState.copyWith(
          createImageUrl: false,
          pictureBoxState: currentState.file != null ? PictureBoxState.imagePicked : PictureBoxState.pickImage,
          pageCommand: ShowErrorMessage("Error on selecting image"));
    } else {
      final File? file = result.asValue!.value;
      if (file != null) {
        return currentState.copyWith(
            createImageUrl: true,
            file: result.asValue!.value,
            // ignore: avoid_redundant_argument_values
            imageUrl: null,
            pictureBoxState: PictureBoxState.imagePicked);
      } else {
        return currentState.copyWith(createImageUrl: false, pictureBoxState: PictureBoxState.pickImage);
      }
    }
  }
}
