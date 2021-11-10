import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/mappers/cancel_invite_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/mappers/get_invites_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/cancel_invite_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/load_invites_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_events.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

/// --- BLOC
class ManageInvitesBloc extends Bloc<ManageInvitesEvent, ManageInvitesState> {
  ManageInvitesBloc() : super(ManageInvitesState.initial());

  @override
  Stream<ManageInvitesState> mapEventToState(ManageInvitesEvent event) async* {
    if (event is LoadInvites) {
      yield state.copyWith(pageState: PageState.loading);
      final InvitesDto? result = await GetInvitesUseCase().run();
      yield GetInvitesStateMapper().mapResultToState(state, result);
    } else if (event is OnCancelInviteTapped) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await CancelInviteUseCase().run(event.inviteHash);
      // If we succeed with the cancel, refresh the data
      if (result.isValue) {
        add(LoadInvites());
      }
      yield CancelInviteStateMapper().mapResultToState(state, result);
    }
  }
}
