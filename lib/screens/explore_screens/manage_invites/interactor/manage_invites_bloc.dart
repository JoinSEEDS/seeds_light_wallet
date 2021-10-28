import 'package:bloc/bloc.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_events.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

/// --- BLOC
class ManageInvitesBloc extends Bloc<ManageInvitesEvent, ManageInvitesState> {
  ManageInvitesBloc() : super(ManageInvitesState.initial());

  @override
  Stream<ManageInvitesState> mapEventToState(ManageInvitesEvent event) async* {}
}
