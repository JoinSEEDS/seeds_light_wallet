import 'dart:io';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_page_commands.dart';

class PickImageStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState, Result<File> result) {
    if (result.isError) {
      return currentState.copyWith(
          createImageUrl: false,
          pictureBoxState: currentState.file != null ? PictureBoxState.imagePicked : PictureBoxState.pickImage,
          pageCommand: ShowErrorMessage("Error on selecting image"));
    } else {
      return currentState.copyWith(
          file: result.asValue!.value,
          createImageUrl: true,
          pictureBoxState: PictureBoxState.imagePicked,
          pageCommand: RemoveAuthenticationScreen());
    }
  }
}
