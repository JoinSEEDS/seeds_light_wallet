import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/load_invites_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

class GetInvitesStateMapper extends StateMapper {
  ManageInvitesState mapResultToState(ManageInvitesState currentState, InvitesDto? invitesDto) {
    if (invitesDto == null) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final invites = invitesDto.invites;
      final Iterable<ProfileModel> accounts =
          invitesDto.accounts.map((e) => e.isError ? null : e.asValue).whereType<ProfileModel>();

      final List<InvitesItemsData> invitesItemData = invites.map((InviteModel e) => matchElement(e, accounts)).toList();

      return currentState.copyWith(
        pageState: PageState.success,
        invitesItemData: invitesItemData,
      );
    }
  }

  InvitesItemsData matchElement(InviteModel e, Iterable<ProfileModel> accounts) {
    final matching = accounts.where((element) => element.account == e.account);
    final firstMach = matching.isEmpty ? null : matching.first;

    return InvitesItemsData(e, firstMach);
  }
}

class InvitesItemsData {
  final InviteModel invite;
  final ProfileModel? profileModel;

  InvitesItemsData(this.invite, this.profileModel);
}
