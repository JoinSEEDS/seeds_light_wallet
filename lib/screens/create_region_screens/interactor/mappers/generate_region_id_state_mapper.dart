import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_page_commands.dart';

class GenerateRegionIdStateMapper extends StateMapper {
  /// Generate a suggested Region Id for the user based on the Region name entered.
  ///
  /// This will remove any special characters and spaces.
  CreateRegionState mapResultToState(CreateRegionState currentState) {
    String suggestedRegionId = currentState.regionName
        .toLowerCase()
        .trim()
        .split('')
        .map((char) => RegExp('[a-z]|1|2|3|4|5').allMatches(char).isNotEmpty ? char : '')
        .join();

    // Max length for Region id is 8.
    if (suggestedRegionId.length > 8) {
      suggestedRegionId = suggestedRegionId.substring(0, 8);
    }

    return currentState.copyWith(
      pageState: PageState.success,
      regionId: suggestedRegionId,
      createRegionsScreens: CreateRegionScreen.regionId,
      pageCommand: ValidateGeneratedRegionId(),
    );
  }
}
