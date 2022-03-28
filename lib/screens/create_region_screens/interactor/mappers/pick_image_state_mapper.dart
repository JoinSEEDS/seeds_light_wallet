import 'dart:io';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class PickImageStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState, Result<File> result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.success,
          pictureBoxState: currentState.file != null ? PictureBoxState.imagePicked : PictureBoxState.pickImage,
          pageCommand: ShowErrorMessage("Error on selecting image"));
    } else {
      return currentState.copyWith(
          pageState: PageState.success,
          file: result.asValue!.value,
          isUploadImageNextButtonEnable: true,
          // ignore: avoid_redundant_argument_values
          imageUrl: null,
          pictureBoxState: PictureBoxState.imagePicked);
    }
  }
}
