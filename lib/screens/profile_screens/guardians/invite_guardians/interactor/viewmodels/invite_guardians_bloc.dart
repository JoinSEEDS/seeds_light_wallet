import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/mappers/invite_guardian_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/usecases/send_guardian_invite_use_case.dart';

part 'invite_guardians_event.dart';
part 'invite_guardians_state.dart';

class InviteGuardiansBloc extends Bloc<InviteGuardiansEvent, InviteGuardiansState> {
  InviteGuardiansBloc(Set<ProfileModel> myGuardians) : super(InviteGuardiansState.initial(myGuardians)) {
    on<OnSendInviteTapped>(_onSendInviteTapped);
    on<InviteGuardianClearPageCommand>((_, emit) => emit(state.copyWith()));
  }
  Future<void> _onSendInviteTapped(OnSendInviteTapped event, Emitter<InviteGuardiansState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await SendGuardianInviteUseCase().run(state.selectedGuardians);
    emit(InviteGuardiansStateMapper().mapResultToState(state, result));
  }
}
