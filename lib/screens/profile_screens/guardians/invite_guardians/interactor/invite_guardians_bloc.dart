import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/mappers/invite_guardian_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/usecases/send_guardian_invite_use_case.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_events.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';

class InviteGuardiansBloc extends Bloc<InviteGuardiansEvent, InviteGuardiansState> {
  InviteGuardiansBloc(Set<MemberModel> myGuardians) : super(InviteGuardiansState.initial(myGuardians));

  @override
  Stream<InviteGuardiansState> mapEventToState(InviteGuardiansEvent event) async* {
    if (event is OnSendInviteTapped) {
      yield state.copyWith(pageState: PageState.loading);
      final result = await SendGuardianInviteUseCase().run(state.selectedGuardians);
      yield InviteGuardiansStateMapper().mapResultToState(state, result);
    } else if (event is InviteGuardianClearPageCommand) {
      yield state.copyWith();
    }
  }
}
