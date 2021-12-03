import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/mappers/cancel_invite_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/mappers/get_invites_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/cancel_invite_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/usecases/load_invites_use_case.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/invites_items_data.dart';

part 'manage_invites_event.dart';
part 'manage_invites_state.dart';

class ManageInvitesBloc extends Bloc<ManageInvitesEvent, ManageInvitesState> {
  ManageInvitesBloc() : super(ManageInvitesState.initial()) {
    on<OnLoadInvites>(_onLoadInvites);
    on<OnCancelInviteTapped>(_onCancelInviteTapped);
  }

  Future<void> _onLoadInvites(OnLoadInvites event, Emitter<ManageInvitesState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final InvitesDto? result = await GetInvitesUseCase().run();
    emit(GetInvitesStateMapper().mapResultToState(state, result));
  }

  Future<void> _onCancelInviteTapped(OnCancelInviteTapped event, Emitter<ManageInvitesState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await CancelInviteUseCase().run(event.inviteHash);
    // If we succeed with the cancel, refresh the data
    if (result.isValue) {
      add(const OnLoadInvites());
    }
    emit(CancelInviteStateMapper().mapResultToState(state, result));
  }
}
