import 'package:bloc/bloc.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/mappers/get_invites_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/load_invites_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_events.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

/// --- BLOC
class ManageInvitesBloc extends Bloc<ManageInvitesEvent, ManageInvitesState> {
  ManageInvitesBloc() : super(ManageInvitesState.initial());

  @override
  Stream<ManageInvitesState> mapEventToState(ManageInvitesEvent event) async* {
    if (event is LoadInvites) {
      final InvitesDto? result = await GetInvitesUseCase().run();
      yield GetInvitesStateMapper().mapResultToState(state, result);
    }
  }
}
