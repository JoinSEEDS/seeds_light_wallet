import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/usecases/get_vouched_initial_data_use_case.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_bloc.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_page_commands.dart';

class VouchedInitialDataStateMapper extends StateMapper {
  VouchedState mapResultToState(VouchedState currentState, Result<VouchedDto> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      final ProfileModel userProfile = result.asValue!.value.userProfile;

      if (userProfile.status == ProfileStatus.visitor) {
        return currentState.copyWith(
            pageState: PageState.success, canVouch: false, pageCommand: ShowNotQualifiedToVouch());
      } else {
        final vouchedList = result.asValue!.value.vouchedUsers;
        return currentState.copyWith(pageState: PageState.success, canVouch: true, vouched: vouchedList);
      }
    }
  }
}
