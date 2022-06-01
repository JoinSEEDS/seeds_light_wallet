import 'dart:io';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';

class PickRegionImageStateMapper extends StateMapper {
  EditRegionState mapResultToState(EditRegionState currentState, Result<File> result) {
    if (result.isError) {
      return currentState.copyWith(
          pictureBoxState: currentState.file != null ? PictureBoxState.imagePicked : PictureBoxState.pickImage,
          pageCommand: ShowErrorMessage("Error on selecting image"));
    } else {
      return currentState.copyWith(
        file: result.asValue!.value,
        pictureBoxState: PictureBoxState.imagePicked,
        isSaveChangesButtonEnable: true,
      );
    }
  }
}
