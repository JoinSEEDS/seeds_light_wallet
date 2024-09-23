import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class TransferExpertStateMapper extends StateMapper {
  TransferExpertState mapResultToState({
    required TransferExpertState currentState,
    required Result<List<ProfileModel>> seedsMembersResult,
    required Result<List<ProfileModel>> telosResult,
    required Result<List<ProfileModel>> fullNameResult,
    List<String>? noShowUsers,
  }) {
    if (seedsMembersResult.isError && telosResult.isError && fullNameResult.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Searching for User');
    } else {
      final List<ProfileModel> seedsUsers = seedsMembersResult.asValue?.value ?? [];
      final List<ProfileModel> telosUsers = telosResult.asValue?.value ?? [];
      final List<ProfileModel> fullNameUsers = fullNameResult.asValue?.value ?? [];

      final existingSet = <String>{};
      final noShowSet = Set.from(noShowUsers ?? []);

      /// This is the order in which the list will display
      /// - first account name matches
      /// - second full name matches
      /// - third Telos account name matches
      final users = seedsUsers + fullNameUsers + telosUsers;

      final uniqueUsers = <ProfileModel>[];

      for (final member in users) {
        if (!(existingSet.contains(member.account) || noShowSet.contains(member.account))) {
          uniqueUsers.add(member);
          existingSet.add(member.account);
        }
      }

      if (currentState.showOnlyCitizenshipStatus != null) {
        uniqueUsers.removeWhere((element) => element.status != currentState.showOnlyCitizenshipStatus);
      }

      return currentState.copyWith(pageState: PageState.success, users: uniqueUsers);
    }
  }
}
