import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/sponsor_tab/interactor/viewmodels/sponsor_bloc.dart';

class LoadSponsorsStateMapper extends StateMapper {
  SponsorState mapResultToState(SponsorState currentState, Result<List<ProfileModel>> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Sponsors');
    } else {
      return currentState.copyWith(pageState: PageState.success, sponsors: result.asValue!.value);
    }
  }
}
