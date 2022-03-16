import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class GenerateRegionIdStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState) {
    //Generate a suggested Region Id for the user based on the Region name they entered
    String suggestedRegionId = currentState.regionName.toLowerCase().trim().split('').map((character) {
      // ignore: unnecessary_raw_strings
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(character).isNotEmpty;

      return legalChar ? character : '';
    }).join();

    if (suggestedRegionId.length > 8) {
      suggestedRegionId = suggestedRegionId.substring(0, 8);
    }

    return currentState.copyWith(
        pageState: PageState.success,
        regionId: suggestedRegionId,
        createRegionsScreens: CreateRegionScreen.regionId,
        isRegionIdNextButtonEnable: true);
  }
}
